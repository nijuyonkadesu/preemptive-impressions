Self Reflection:
My messages are often disliked by managers.
So, I had to reflect on myself and the reality of my surrounding to find the sweet spot to communicate effectively.

- The tone of my messages resembles a technical status report or a catalog of problems encountered, rather than a structured proposal seeking a specific decision.
- I have technical problem-solving mindset and it clashes with a business communication mindset?

# Findings

I gave LLMs several snippets of my own messages and my colleague's to spot the glaring differences.

## Deepseek:

Problems:

- Lack of High-Level Context
- Overwhelming Detail
- Unclear Asks
- Negative Framing

---

## Gemini:

### Understanding Manager Preferences:

- preferred messages tend to have a clear purpose stated upfront
- They also seem more concise and focused on the key issue for the manage

### Differences in Focus:

- your manager dislikes seem to dive into technical details quickly without always establishing the main point for them
- focus more on listing findings or problems, sometimes with broad questions
- prefers messages that quickly convey the main point or recommendation

### Content:

The primary focus remains on the decision required
the principle of providing sufficient information tailored to the audience's needs

### Tone:

- Write in the active voice
- The tone is professional, direct, and notably proactive
- The sender comes across as having already analyzed the situation, identified potential issues or options, and is now seeking specific guidance, validation, or collaborative input on the next steps.
- This, reflects an assertive communication style where the sender takes ownership of the analysis phase and presents the information ready for managerial input or decision
- The questions are broad ("how should we go about...") rather than presenting concrete options ("should we pursue Option A or Option B?").

### Framing:

- Translate Technical to Business Impact: Always connect the technical issue to its potential effect on the business. Frame it using the language of risk (e.g., security vulnerabilities, data loss, compliance failure), cost (e.g., increased operational expenses, budget overruns, potential fines), time (e.g., project delays, missed deadlines, increased processing time), quality (e.g., system instability, inaccurate data, poor user experience), or strategic goals.

### Framework:

- Use Answer First / BLUF

---

## Claude:

1. Problem-focused: They start by clearly stating the specific problem or challenge being addressed.
2. Structured options: They present clear-cut alternatives with well-defined pros and cons.
3. Direct questions: They end with specific questions asking for guidance or input.
4. Technical clarity: They provide just enough technical detail without overwhelming.
5. Businesslike tone: They maintain a professional, neutral tone.

What you're missing:

- Directness: Your manager likely values getting to the point quickly.
- Decision readiness: The preferred messages are set up to facilitate a decision.
- Audience awareness: The disliked messages seem more like internal thought processes than executive-ready communications.
- Visual simplicity: Clean formatting without emoji, excess symbols, or overly complex nesting.

How to improve:

- Start with a one-sentence description of what you're working on
- Present options clearly if needed (no more than 2-3)
- End with a specific question or request for input
- Tag relevant people at the beginning or with the specific question
- Remove visual clutter and simplify formatting
- Make sure your message can be read and understood quickly

---

## GPT:

### Include:

- context,
- challenges,
- possible solutions,
- question/ask

1. prefers brevity and focus
2. summarizing the expected impact of the decision or the benefits of a particular approach up front
3. questions at the end
4. The “liked” examples tend to have a neutral tone that avoids unnecessary embellishments. They are professional, direct, and respectful of the reader’s time.

---

# Usable Templates

1. Start with context but get to the point quickly
2. Present clear options when applicable
3. Connect technical details to business impact
4. End with a specific question that facilitates decision-making
5. Maintain a professional, direct tone
6. Keep formatting clean and simple
7. Avoid emoji, warning symbols, or complex nested structures

## 01 - Decision Between Options

[Brief context about the project/task] I need guidance on [specific decision].

I'm considering two approaches:

1. [Option 1]: [Brief description with main benefit]
2. [Option 2]: [Brief description with main benefit]

The key factor is [business impact/consideration]. Which approach would you recommend for moving forward?

## 02 - Problem-Solution

We're facing [specific issue] with [project/feature]. This impacts [business outcome/deadline].

After analysis, I recommend [proposed solution] because it [main advantage].

Alternative options considered:

- [Alternative]: [Brief reason why not preferred]

Do you agree with this approach?

## 03 - Status Update with Blocker

[Project name] update: We've completed [achievements] and are on track for [upcoming milestone].

We've encountered a blocker with [specific issue]. This may impact [timeline/deliverable].

To resolve this, I suggest [specific action]. Would you approve this approach?

## 04 - Technical Decision with Business Impact

For [feature/project], I need to decide on [technical aspect]. This will affect [performance/scalability/maintenance].

The optimal solution appears to be [recommendation] because [business benefit].

Is this aligned with our priorities for this quarter?

## 05 - Resource Request

To deliver [specific outcome] by [deadline], I need [specific resource/person/tool].

Without this, we risk [specific business impact]. With it, we gain [specific benefit].

Can we secure this resource by [date]?

## 06 - Process Improvement

I've identified an opportunity to improve our [process/workflow]. Currently, [brief description of current state] which causes [problem].

By implementing [change], we could [specific benefit with metrics if possible].

Would you support piloting this approach?

# Pre-Task Discovery Questions

## Requirements & Scope

1. What specific problem are we trying to solve with this research?
2. What are the expected deliverables from this task?
3. How will success be measured for this discovery effort?
4. _Are there any assumptions we're making that I should validate first?_
5. _What parts of this task are flexible vs. non-negotiable?_

## Technical Considerations

6. What systems or data sources will I need access to?
7. Are there performance constraints I should be aware of?
8. _Have we attempted something similar before? What were the outcomes?_
9. _What technology limitations might impact the potential solutions?_
10. _Are there existing components/approaches we should leverage?_

## Dependencies & Resources

11. Who are the key stakeholders I should consult during this process?
12. What teams or individuals does this work depend on?
13. Are there any pending decisions that might affect this task?
14. _What documentation or background information is available?_
15. Do I have all necessary permissions and credentials for the systems involved?

## Timeline & Priority

16. _When do we need these findings by?_
17. How does this research fit into our broader roadmap?
18. _What other work might need to be reprioritized if this becomes complex?_
19. Is there a budget constraint for any solutions we might propose?
20. How much time should I allocate for this discovery before we reassess?

## Risk Assessment

21. What are the known obstacles we've already identified?
22. What's the business impact if we can't find a viable solution?
23. Are there compliance or security concerns I should consider?
24. What contingency plans should we have if the discovery reveals unfeasible requirements?
25. _What precedents or similar tasks can I review to anticipate potential issues?_
