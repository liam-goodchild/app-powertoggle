## PowerToggle – Simple VM Scheduling with Tags

This is a lightweight solution for starting and stopping Azure VMs based on a tag system.

I built this because Microsoft's `StartStopV2` felt overengineered for what should be a straightforward task. This solution uses Logic Apps to evaluate VM tags on a schedule and perform start and deallocate actions with minimal overhead.

### How It Works

Add the following tags to any VM:

- `AutoStart : 08:00`
- `AutoStop : 18:00`

The Logic App parses these tags, checks the current time, and performs actions accordingly. It supports:

- Weekday-only operations
- Time zone handling

### Why Use This?

- No legacy Automation Accounts
- No reliance on Microsoft’s bulky `StartStopV2` solution
- Easy to understand, easy to maintain
- Fully deployable via Bicep

This was designed to do one thing well without unnecessary complexity.
