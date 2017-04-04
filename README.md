# DynamicHeightFooters
My attempt to investigate application of autolayout for table view section headers/footers. Lots of fun, really.

## Intro
Tap [DK:] button to change the kind of table view delegate:

* "-" `nil` delegate
* "D" custom delegate (custom, enables custom dynamic height sections/footers)
* "V" view controller (default for `UITableViewController`)

Note: `nil` delegate does not work after other delegates are being set, so it is the initial delegate.

Layout margins for the section/footers can be set in code. See `verticalHeaderMargins` and `verticalFooterMargins` in `DynamicCustomFooterTableViewDelegate`.
