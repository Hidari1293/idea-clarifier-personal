# NOTICE — 来源、许可与改动说明

本文件说明本项目的来源、上游许可证，以及哪些部分是复用、哪些是新增。
MIT 许可要求保留版权声明与许可声明，因此本文件与 `LICENSE`、`LICENSE-interview-me` 需一并保留。

## 本 Skill

- 名称：`idea-clarifier-personal`
- 版本：1.1.0
- 性质：个人需求澄清工作流，面向 Agent Skills 生态（WorkBuddy、Claude Code 等）

## 上游来源

访谈机制改编自 **interview-me**：

- 作者：Addy Osmani
- 仓库：https://github.com/addyosmani/agent-skills
- 路径：`skills/interview-me/SKILL.md`
- 许可证：MIT License，Copyright (c) 2025 Addy Osmani
- 许可证全文：本目录 `LICENSE-interview-me`

**本项目未包含上游代码副本**，也未修改上游文件。上游 Skill 需单独安装（见 README「同时安装原版」）。

## 改编范围

### 复用上游的部分（未重新发明）

- 一次只问一个问题，每问附带自己的猜测
- 提问前先写下假设与置信度，置信度偏低时说明还缺什么
- 识别「想要」与「应该想要」的差别
- 复述意图并要求显式确认，拒绝「随便你」类空洞确认
- 以「能否预测接下来三个问题的反应」为停止条件
- 确认后立即停止本轮，不擅自启动下游工作

### 本项目新增的部分

- 中文优先的表达与去术语化规则
- 七维理解度拆解，替代单一置信度数字
- 需求来源三分法 `[A] / [B] / [C]`
- 场景模拟与方案比较的具体做法（含选项设计原则、六轴比较、矛盾处理）
- 用户答不上来时的四级降级
- 按复杂度分档的访谈深度
- 进度文件的保存与恢复协议
- 意图总结 / PRD / Agent 执行提示词三份交付物模板
- 交付前置门槛（`[A]` 不足时不许硬写完整 PRD）

## 设计取舍：为什么不在运行时调用上游

跨 Skill 的动态调用依赖模型自行决定加载，属于不稳定链路，无法保证每次访谈都触发。
因此把必要的核心机制以**改写**方式内置（`SKILL.md` 与 `references/interview-core.md`），
使本项目可独立运行。需要上游完整机制（全部红旗清单与合理化对照表）时，直接安装并调用 `interview-me`。

这是 MIT 许可允许的用法，条件是在副本中保留版权声明与许可声明 —— 已通过
`LICENSE`、`LICENSE-interview-me` 与本文件满足。

## 上游署名要求

若二次分发、修改或商用本项目，请保留：

1. `LICENSE`、`LICENSE-interview-me`、`NOTICE.md` 三个文件；
2. README 与本文档中对 Addy Osmani 及 interview-me 的署名与链接；
3. 对改写部分的说明（说明这不是上游原版）。
