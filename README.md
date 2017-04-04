# DynamicHeightFooters

My attempt to investigate application of autolayout for table view section headers/footers. Lots of fun, really.

## Intro

Tap "DK:" button to change the kind of table view delegate:

* "-" `nil` delegate
* "D" custom delegate (custom, enables custom dynamic height sections/footers)
* "S" custom delegate that tries to use standard table header view, without adding constraints/custom view and etc. (Does not work so far).
* "V" view controller (default for `UITableViewController`)

Note: `nil` delegate does not work after other delegates are being set, so it is the initial delegate.

Each header should show a set of lines like hN-0..hN-N where N is the section index. Same story with fN-0..fN-N (section footers) and 0-sN..N-sN (single cell inside every section when custom cells are enabled) or sN (for standard cells). If you don't see the whole text, or some lines are "missing" it means that they were clipped due to incorrect layout.

# Buttons

I just tried to put all the configuration on screen to be able to identify the configuration on the screenshot.

* "DK:" toggles between different delegate kinds (see above)
* "Margins": enables accounting layout margins in estimated heights
* "Footers", "Headers": toggles footers/headers
* "M:" stepper for changing _top margin_ above every section _header_ (Just to see what happens (read: breaks) for different margin values).
* "E:" stepper for changing estimated height value for both section header and footer.
* "C" toggles custom (dynamic height) *cells*

## What should work

* `DK:V` (apparently)
* `DK:D` with [Margins].
* `DK:-` only once, after launch

## What does not work

* `DK:S` could not get it right (and I'm not sure whether its possible at all)
* `DK:-` 2nd time, after some kind of other delegate was used before (I don't know why).

## Lesssons learnt

* Estimated section header/footer height should account margins. Especially, if they're larger than usual. (I'm curious whether it's the case with UITableViewCell).
* Layout on iOS 9 might behave/break differently in some cases. Especially in ones that don't account everything (read: corner cases).
* [???] You can not use standard UITableViewSectionHeaderFooterView if you want to adjust anything that affects its layout (like font/spacing and etc.). Probably it's the same story as with UITabeleViewCells.
* Standard headers are _very_ slow, compared to custom ones. I did not investigate what is the reason.
* Look for !!! in the source code. I tried to mark important places. There might be false positives, though.
