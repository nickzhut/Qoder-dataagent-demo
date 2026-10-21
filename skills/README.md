# skills：可移植能力包

Skill 是能力，不是角色。角色是 `squad/routing.yaml` 里的组合；换模型、换执行面不改 Skill。

## 包结构

```text
skills/<name>/
├── SKILL.md          # 何时用、输入输出、边界、反例
├── manifest.yaml     # 版本、输入输出 schema、工具、权限、runtime
├── scripts/          # 确定性执行入口，可单独 CLI 跑
├── tests/            # 无模型的单元测试
└── evals/            # 黄金输入/输出，Agent 级评测
```

## manifest 约定

```yaml
apiVersion: dw.skill/v1
kind: Skill
metadata:
  name: modeling-contract
  version: 1.0.0
spec:
  runtime: [qca, self_hosted, local]
  inputs: {}      # JSON Schema
  outputs: {}     # JSON Schema
  tools: [Read, Write, Glob, Grep, Bash]
  permissions:
    filesystem_write: runs/
    network: none
  evals:
    golden: evals/golden
    pass_threshold: 0.9
```

## 规则

1. 颗粒按动词拆：`semantic-validate`、`modeling-contract`、`sql-build`、`sql-review`、`dq-plan`、`dataworks-apply`、`evidence-collect`。
2. 业务逻辑进 `scripts/`，Prompt 只做编排；禁止在 Prompt 里写表名、口径。
3. 同一份源码三种 runtime 通用：QCA Skill、自托管 Runner CLI、本地调试。
4. 版本 = Git tag + `skills.lock`（映射 QCA `skill_id`/version）；无 eval 不进 registry。
5. 先过 `tests/`（确定性），再过 `evals/`（Agent）；两者都绿才允许被 routing 引用。
