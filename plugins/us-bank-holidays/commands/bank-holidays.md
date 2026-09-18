---
name: bank-holidays
description: List US bank holidays for a given year
arguments:
  - name: year
    description: The year to get holidays for (2026 or 2027)
    required: false
---

You are executing the `/bank-holidays` command to provide the US Federal Reserve bank holiday schedule.

The user invoked this command with the following year: {{year}}

Follow these rules exactly:

1. If the user did not provide a year (i.e. it is empty or undefined), ask them which year they want (2026 or 2027) and do not provide any holidays.
2. If the user provided a year other than 2026 or 2027, tell them that the year is out of range for this version of the plugin, and ask them to pick either 2026 or 2027.
3. If the user provided 2026 or 2027, output a clean markdown table of the holidays for that year with columns: `Holiday`, `Date`, `Day of Week`.
4. Include a one-line note below the table for any holiday with a weekend observance footnote. Do not invent or estimate any other dates.

Here is the official Federal Reserve holiday schedule data to use:

### 2026
- New Year's Day: January 1, 2026 (Thursday)
- Birthday of Martin Luther King Jr.: January 19, 2026 (Monday)
- Washington's Birthday (Presidents Day): February 16, 2026 (Monday)
- Memorial Day: May 25, 2026 (Monday)
- Juneteenth National Independence Day: June 19, 2026 (Friday)
- Independence Day: July 4, 2026 (Saturday) — observed July 3, 2026 for the Board of Governors; Reserve Banks remain open
- Labor Day: September 7, 2026 (Monday)
- Columbus Day: October 12, 2026 (Monday)
- Veterans Day: November 11, 2026 (Wednesday)
- Thanksgiving Day: November 26, 2026 (Thursday)
- Christmas Day: December 25, 2026 (Friday)

### 2027
- New Year's Day: January 1, 2027 (Friday)
- Birthday of Martin Luther King Jr.: January 18, 2027 (Monday)
- Washington's Birthday (Presidents Day): February 15, 2027 (Monday)
- Memorial Day: May 31, 2027 (Monday)
- Juneteenth National Independence Day: June 19, 2027 (Saturday) — observed June 18, 2027 for the Board of Governors
- Independence Day: July 4, 2027 (Sunday) — Reserve Banks and Board of Governors closed July 5, 2027
- Labor Day: September 6, 2027 (Monday)
- Columbus Day: October 11, 2027 (Monday)
- Veterans Day: November 11, 2027 (Thursday)
- Thanksgiving Day: November 25, 2027 (Thursday)
- Christmas Day: December 25, 2027 (Saturday) — observed December 24, 2027 for the Board of Governors

Output ONLY the response following the rules above, without extra conversational filler.
