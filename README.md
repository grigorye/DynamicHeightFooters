# DynamicHeightFooters

My attempt to investigate application of autolayout for table view section headers/footers. Lots of fun, really.

## Intro

Tap [DK:] button to change the kind of table view delegate:

* "-" `nil` delegate
* "D" custom delegate (custom, enables custom dynamic height sections/footers)
* "V" view controller (default for `UITableViewController`)

Note: `nil` delegate does not work after other delegates are being set, so it is the initial delegate.

Layout margins for the section/footers can be set in code. See `verticalHeaderMargins` and `verticalFooterMargins` in `DynamicCustomFooterTableViewDelegate`.

## What should work

* `DK:V` (apparently)
* `DK:D` with [Margins].
* `DK:-` only once, after launch

## What does not work

* `DK:S` could not get it right (and I'm not sure whether its possible at all)
* `DK:-` 2nd time, after some kind of other delegate was used before (I don't know why).
