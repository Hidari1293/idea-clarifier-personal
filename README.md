# idea-clarifier-personal

> 把「我有个想法，但说不清」变成「这就是我要的，可以开工了」。

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Agent Skills](https://img.shields.io/badge/Agent%20Skills-SKILL.md-blue)

一个给 **Claude Code / WorkBuddy / Codex** 等 Agent 用的需求澄清 Skill。
它不写代码，只做一件事：在你动手之前，把你的真实需求问出来，并整理成下一个 Agent 能直接执行的东西。

---

## 它解决什么问题

你有想法，但说不清要什么功能；你不懂产品术语，也不想先学怎么写 Prompt。
于是你对 Agent 说「我想做个帮我学日语的东西」——

**普通 Agent 的反应**：给你一套背单词功能清单（记忆曲线、错词本、每日打卡、数据统计）。
看起来很专业，但它回答的是别人的问题。你当时想要的，可能只是「每天不用费力也能碰到日语」。

**这个 Skill 的反应**：

```
我的猜测：你要的不是一个更严格的背单词工具，而是让日语每天出现一次，别断掉。
理解度：约 30%｜还缺：你之前怎么学的、断在哪
问：这件事你现在是怎么应付的？
我猜：用过某个 App，连续打卡几天，然后停了。依据是你用了「学」这个字，
      通常意味着试过正规办法。
```

两三个问题之后，方向往往会变。**变方向是目的，不是失败**——在写下第一行方案之前改主意，成本为零。

## 和 interview-me 的关系

本项目建立在 [interview-me](https://github.com/addyosmani/agent-skills/tree/main/skills/interview-me)
（作者 [Addy Osmani](https://github.com/addyosmani)，MIT 许可）之上。**它不是重写，是增强层。**

| | interview-me（上游） | idea-clarifier-personal（本项目） |
|---|---|---|
| 职责 | 听懂你 | 帮你想清楚，并交给下一个 Agent |
| 核心机制 | 一次一问、附带猜测、置信度、复述、显式确认 | **复用同一套机制**，不另造访谈系统 |
| 面向 | 任何需要澄清的请求 | 说不清需求的非专业用户 |
| 语言 | 英文 | 中文优先，去术语 |
| 产出 | 已确认的意图陈述 | 意图总结 → 按需 PRD / 执行提示词 |

上游解决的是「Agent 别自作聪明」；本项目解决的是「用户自己也不知道要什么」。
前者是防止 Agent 猜错，后者是帮用户把没成形的东西想出来。

上游 `SKILL.md` 未被修改，本项目也不包含它的代码副本。署名与许可要求见 [NOTICE.md](NOTICE.md)。

## 怎么工作

| 阶段 | 做什么 | 关键约束 |
|---|---|---|
| 0 接住 | 复述你的话，给出猜测与理解度 | 不给任何方案 |
| 1 动机与场景 | 问「现在怎么应付」，不问「你的目标是什么」 | 一次只问一个 |
| 2 体验模拟 | 把你放进一个具体场景，给 3–4 种体验让你选 | 选项来自你说过的话，必须有「都不对」 |
| 3 方案比较 | 一次只比一个轴，说清感受与代价 | 给倾向，但决定权交回 |
| 4 复述 | 七行复述：想做的事 / 为什么 / 谁用 / 场景 / 最在意 / 明确不做 / 硬约束 | 「明确不做」不能省 |
| 5 确认 | 只有明确的「对」才算确认 | 「随便你」「还行」都不算 |
| 6 交付 | 问你要哪种深度，按需生成 | 不自动生成一堆文件 |

## 四项增强

### 1. 非专业用户引导

接受口语、断句、跳跃。不要求你用术语，前 5 轮不出现「用户画像」「MVP」「技术栈」。
当你说得含糊，它给一个理解让你判断（「我理解成 A，不是 B，对吗？」），而不是让你从零重说一遍。

### 2. 场景模拟

说不出功能时，不再追问「你想要什么功能」，改成让你在体验里选：

```
假设你昨天学了十个新词。今天早高峰在地铁上，你掏出手机打开它。
你希望第一屏是什么？

A. 直接开始测昨天那十个词，错了的留下来重来
B. 一篇用那十个词写的小短文，读完大概看懂就行
C. 一句日语问你「昨天学的，还记得几个？」，你点一下才进复习
D. 都不是，我想要的是另一种感觉
```

选完追问一句「为什么是它」——理由比选项本身有用。这是体验探针，不是问卷。

### 3. 方案比较

一次只比一个轴：简单工具 vs 平台、全自动 vs 可控、固定流程 vs 自由、本地 vs 云端、一次做到位 vs 迭代。
每个方案说三件事：用起来什么感觉、代价是什么、做起来多复杂。最后问「你更怕哪个代价」。

**发现矛盾不绕过去**。你说「功能要全，但必须极简零配置」，它会指出冲突发生在「第一次打开」还是「第十次使用」，给两三条折中路径，然后让你选。

### 4. 个人化沟通

像懂行的朋友，不像问卷。不奉承、不盲从、可以不同意但给理由。
你可以随时暂停、回退、结束，不追问理由。

## 几个关键机制

**七维理解度**：目标 / 动机 / 场景 / 体验 / 功能 / 约束 / 边界。每次只报最缺的 1–3 项，不报总分。
百分数只代表「能否预测你对下一个问题的反应」，不是进度条。

**需求来源三分法**：任何产出里，每条需求都标来源。

| 标签 | 含义 |
|---|---|
| `[A]` | 你明确说过并确认 |
| `[B]` | 它提出、你还没表态（必须带「建议，待确认」） |
| `[C]` | 还没谈到（单列「未决」） |

硬规则：`[B]` 不能写成陈述句需求。这条看起来啰嗦，但它是防止「Agent 的建议变成你的需求」的唯一可靠办法。

**四级降级**：你答不上来时，同一个抽象问题最多问一次。第二次换成具体场景 → 三个例子 → 二选一 → 「我先替你假设，你只说对不对」。

**进度文件**：`docs/idea/<项目名>/progress.md`，记录已确认、待确认、未决、问过的问题、下一步、变更日志。
新会话说「继续上次那个 X」，它先读文件，不会让你重答。

## 安装

### 方式一：脚本（推荐）

```bash
git clone https://github.com/<你的用户名>/idea-clarifier-personal.git
cd idea-clarifier-personal
./install.sh
```

脚本会检测 `~/.workbuddy/skills/` 与 `~/.claude/skills/` 是否存在，存在就装进去；
已存在同名 Skill 时先改名为 `.bak.<时间戳>` 再写入，不会静默覆盖。

### 方式二：手动复制

```bash
git clone https://github.com/<你的用户名>/idea-clarifier-personal.git
cp -r idea-clarifier-personal ~/.claude/skills/          # Claude Code
cp -r idea-clarifier-personal ~/.workbuddy/skills/       # WorkBuddy
```

只给某个项目用，放到该项目的 `.claude/skills/` 或 `.workbuddy/skills/` 下即可。

安装完**新开一个会话**。技能只在会话启动时扫描。

### 同时安装原版

本 Skill 可独立运行。想要上游完整的红旗清单与合理化对照表，再装一份：

```bash
git clone --depth 1 https://github.com/addyosmani/agent-skills.git /tmp/agent-skills
mkdir -p ~/.claude/skills/interview-me
cp /tmp/agent-skills/skills/interview-me/SKILL.md ~/.claude/skills/interview-me/
```

## 使用

| 场景 | 你说 |
|---|---|
| 主动调用 | 「用 idea-clarifier-personal 帮我理一下：我想做…」 |
| 自然触发 | 「我有个想法但说不清楚」「帮我想想该做什么功能」 |
| 恢复进度 | 「继续上次那个读书笔记的想法」 |
| 只要原版 | 「用 interview-me 访谈我」 |

技能是否自动触发取决于模型对 description 的判断，不保证 100% 命中，所以手动调用入口一直有效。

## 产出长什么样

访谈确认后，按需生成。简单想法只给一份意图总结（十行以内），复杂项目才追加 PRD 和执行提示词。

```markdown
- 想做的事：读完一本书，两个月后还能想起它讲了什么
- 为什么现在想做：记了从不回看，等于白记
- 谁会用：只有我自己 [A]
- 典型场景：饭桌上聊到这本书，能讲两分钟
- 最在意的体验：不要有被复习绑住的感觉 [A]
- 明确不做：复习卡片、打卡提醒 [A]
- 硬约束：手机上能打开，不装额外软件 [C 未定]
```

PRD 与执行提示词模板见 [`references/deliverables.md`](references/deliverables.md)。
两者都强制标注 `[A]/[B]/[C]`，`[A]` 不足时会拒绝写完整 PRD——宁可交一份草稿，也不交一份看起来很完整的空壳。

## 目录结构

```
.
├── SKILL.md                        # 主入口：铁律、七维、三分法、主流程、增强、进度协议
├── references/
│   ├── interview-core.md           # 上游机制的中文改写（含署名）
│   ├── exploration-playbook.md     # 场景模拟配方、六轴比较、矛盾处理、降级台词
│   └── deliverables.md             # 意图总结 / PRD / 提示词 / 进度文件模板
├── LICENSE
├── LICENSE-interview-me            # 上游 MIT 原文
├── NOTICE.md                       # 来源、改编范围、署名要求
├── CHANGELOG.md
└── install.sh
```

## 设计取舍

**为什么内置上游机制，而不是运行时调用？**
跨 Skill 动态调用依赖模型自行决定加载，无法保证触发。为了让「一次访谈必须走完整流程」这件事可靠，只能内置。
代价是本项目要跟随上游的思想演进手动同步——这是明知的取舍，不是疏忽。

**为什么强调「一次只问一个」？**
一次给五个问题，用户会扫读、给表层答案，而第三个问题往往取决于第一个的答案。批量提问等于锁死错误前提。

**为什么要有 `[B]`？**
因为 Agent 最危险的失败不是问错，而是把「我觉得你该有」写成「你要有」。标出来源，你才有机会否掉。

## 局限

- **需要真人来回**。不能用在 CI、定时任务、自动化流水线里。
- **问得慢**。复杂项目可能 10–20 轮。急着开工时应该直接说「别问了，先做」——它会尊重，只提醒一次最贵的风险。
- **不替你做产品决策**。它只会把取舍摆清楚，最后仍然是你选。
- 中文语料为主，英文可用但话术未针对英文习惯优化。
- 测试基于模拟访谈与真实文件读写验证，**没有做过大规模真实用户研究**。

## 许可

MIT。见 [LICENSE](LICENSE)。
上游 interview-me 同为 MIT，版权归 Addy Osmani，原文见 [LICENSE-interview-me](LICENSE-interview-me)。
二次分发请保留 [NOTICE.md](NOTICE.md) 中的署名。

## English

**idea-clarifier-personal** is an Agent Skill that turns a vague product idea into an executable brief.

It builds on [interview-me](https://github.com/addyosmani/agent-skills/tree/main/skills/interview-me) by Addy Osmani (MIT).
The one-question-at-a-time interview loop — hypothesis with confidence, a guess attached to every question,
restate-and-confirm — is reused as-is. What this project adds is aimed at users who cannot articulate
requirements at all: concrete scenario probes, trade-off comparisons, a four-level fallback when the user is stuck,
a seven-dimension understanding model, `[A]/[B]/[C]` provenance tags, resumable progress files, and
on-demand deliverables (intent summary → PRD → agent prompt).

Install by copying this directory into `~/.claude/skills/` or `~/.workbuddy/skills/`, then start a new session.
Requires a live human in the loop; do not use in automated pipelines.

## 致谢

- [Addy Osmani](https://github.com/addyosmani) — interview-me，本项目一半以上的方法来自它
- [agent-skills](https://github.com/addyosmani/agent-skills) — Skill 的组织方式参考
