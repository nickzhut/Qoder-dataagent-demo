# DEMO-1 门店日销售概览

## 业务问题

运营需要在晨会上按「门店 × 日」查看销售额、销量、毛利额和来客数，用于发现异常门店并追踪促销效果。

## 指标与维度

| 指标 | 口径 | 类型 |
| --- | --- | --- |
| `sales_amt` | `SUM(item_net_amt)`，仅 `is_valid = 1` | `DECIMAL(18,6)` |
| `sales_qty` | `SUM(sales_qty)`，仅 `is_valid = 1` | `BIGINT` |
| `gross_profit_amt` | `SUM(item_net_amt - item_cost_amt)`，仅 `is_valid = 1` | `DECIMAL(18,6)` |
| `customer_num` | `COUNT(DISTINCT COALESCE(member_id, order_id))` | `BIGINT` |

维度：`shop_id`、`business_date`、`category_id`、`city_id`、`region_id`、`sku_id`。

粒度：门店 × 日（`shop_id` + `business_date`）。

## 语义引用

- `semantic/metrics/sales.yaml`：`sales_amt`、`sales_qty`
- `semantic/metrics/profit.yaml`：`gross_profit_amt`
- `semantic/metrics/traffic.yaml`：`customer_num`
- 实体：`semantic/entities/shop.yaml`、`sku.yaml`、`date.yaml`

## 可用源表（合成数据）

所有表按 `dt` 分区，格式 `yyyy-MM-dd`；`is_valid = 0` 表示退货或无效行。

### ods_trd_order_item_di

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `order_item_id` | STRING | 订单行 ID |
| `order_id` | STRING | 订单 ID |
| `shop_id` | STRING | 门店编码 |
| `sku_id` | STRING | 商品编码 |
| `business_date` | STRING | 营业日期 |
| `member_id` | STRING | 会员 ID，非会员为空 |
| `sales_qty` | BIGINT | 销售数量 |
| `item_net_amt` | DECIMAL(18,6) | 行净销售额 |
| `item_cost_amt` | DECIMAL(18,6) | 行商品成本 |
| `promo_subsidy_amt` | DECIMAL(18,6) | 促销补贴分摊 |
| `is_valid` | BIGINT | 1 有效，0 退货/无效 |

### ods_trd_order_di

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `order_id` | STRING | 订单 ID |
| `shop_id` | STRING | 门店编码 |
| `business_date` | STRING | 营业日期 |
| `member_id` | STRING | 会员 ID，非会员为空 |
| `channel` | STRING | 渠道 |

### ods_mdm_shop_di

`shop_id`、`shop_name`、`city_id`、`region_id`、`open_date`。

### ods_mdm_sku_di

`sku_id`、`sku_name`、`category_id`、`category_name`、`list_price`、`cost_price`。

### ods_trd_promotion_di

`order_item_id`、`promotion_id`、`promo_subsidy_amt`、`bearer`。

## 期望产出

本次 run 只做建模，产出四件套：

- `02-design.md`
- `02-schema.yaml`
- `02-mapping.yaml`
- `02-dq-plan.yaml`

不要写 DDL/ETL，不要修改 `semantic/`。

## 验收标准

1. 四件套齐全，YAML 可解析；
2. 表契约的 `grain` / `primary_key` 与指标 `grain` 对齐；
3. `02-mapping.yaml` 覆盖全部指标表达式所需字段；
4. DQ 覆盖主键唯一、核心字段非空、分区非空、DWS↔DWD 对账；
5. `handoff.md` 的 `artifacts` 路径全部存在。

## 数据分级与权限

合成数据，公开演示级；不含个人信息。仅使用 Demo 环境凭据，不接触生产。

## 截止时间 / 优先级

P0；Phase 0 V1 验证用。
