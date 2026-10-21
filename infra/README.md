# infra：资源层前置校验与幂等供给

四个阶段，全部可重入；`ensure` 永不删除。

```text
scenario.yaml → preflight（只读）→ plan（create/adopt/noop/fail）→ ensure（只执行批准动作）→ verify
```

## 不变式

1. `scenario.yaml` 是唯一期望状态输入；物理资源 ID 写在 `state/<env>.json`，不写回 scenario。
2. `preflight` 只读：region、账号身份、DataWorks 空间（存在性/模式/资源组）、MaxCompute project 与 schema、OSS bucket、RAM 角色、QCA 环境/凭证、仓库可达性（含本仓库的连通性结论）。
3. 已存在资源不是"直接用"：必须校验 region、模式、权限、命名冲突；不兼容则 `fail` 并输出差异，不静默复用。
4. `ensure` 每步返回 `{action, id, fingerprint, evidence}`；重复执行必须 0 变更。
5. 默认 `--dry-run`；`--apply` 才写；`--adopt` 需显式确认；删除/重建是独立命令、独立审批。
6. 并发加锁（lease 文件）；防重复创建。
7. 凭证只进 Vault，不进 state、不进日志、不进仓库。

## 命名

逻辑名（`scenario.spec.*_logical`）决定生成对象的命名；`*_ref` 记录实际采用/创建的物理资源。项目名、工作流名、SQL 里的库名全部由 scenario 渲染，不硬编码。

## 状态

`state/<env>.json` 记录资源 ID、fingerprint、时间戳；团队共享态后续放 OSS，本仓库不入库。
