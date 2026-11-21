# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Product purpose

Lumen Missal is a browser extension for looking up and reading the Catholic liturgical readings for the current day. LitCal determines the celebration and citations, and Bible API supplies scripture in the selected translation.

## Operating context

The main surface is a compact extension popup. Readers can also open the Flutter web app in a browser tab. Settings control appearance, Bible translation, and general, national, or diocesan calendar.

## Capabilities and constraints

- Keep application state in Flutter's ChangeNotifier and keep dependencies small.
- Keep previously fetched passages available when the network is unavailable.
- Show the LitCal celebration and available citations even when scripture text is unavailable.
- Use the confirmed modern utility direction with neutral chrome and sans-serif headings.
