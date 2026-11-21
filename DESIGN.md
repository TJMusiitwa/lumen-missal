---
name: Lumen Missal
description: A compact, neutral interface for daily liturgical readings.
colors:
  surface: "#fdfcfe"
  surface-dark: "#1a1a20"
  canvas: "#ecebf0"
  canvas-dark: "#121217"
  ink: "#23212a"
  ink-dark: "#f3eff7"
  muted-ink: "#5f586b"
  muted-ink-dark: "#bcb6c7"
  low-surface: "#f7f5f9"
  low-surface-dark: "#222128"
  divider: "#e3dfeb"
  divider-dark: "#35323e"
  outline: "#79757f"
  outline-dark: "#938f99"
  primary: "#544387"
  primary-dark: "#d0c1fe"
  primary-fill: "#ece5fa"
  primary-fill-dark: "#39314e"
  primary-ink: "#30234f"
  primary-ink-dark: "#ede4ff"
  control-fill: "#e6dff9"
  control-fill-dark: "#484458"
  control-ink: "#484458"
  control-ink-dark: "#e6dff9"
  liturgical-green: "#228b22"
  liturgical-violet: "#6a0dad"
  liturgical-white: "#ffffff"
  liturgical-gold: "#ffd700"
  liturgical-red: "#8b0000"
  liturgical-rose: "#ffc0cb"
typography:
  headline:
    fontFamily: Inter
    fontSize: 25px
    fontWeight: 600
    lineHeight: 1.18
    letterSpacing: -0.7px
  celebration-title:
    fontFamily: Inter
    fontSize: 19px
    fontWeight: 600
    lineHeight: 1.27
    letterSpacing: -0.4px
  title:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 600
    lineHeight: 1.35
  scripture:
    fontFamily: Inter
    fontSize: 17px
    lineHeight: 1.65
  body:
    fontFamily: Inter
    fontSize: 13px
    lineHeight: 1.5
  metadata:
    fontFamily: Inter
    fontSize: 12px
    lineHeight: 1.45
rounded:
  inset-tile: 9px
  field: 10px
  status: 12px
  celebration: 14px
  tab-frame: 16px
spacing:
  content-gutter: 22px
  celebration-inset: 14px
  status-inset: 14px
  tab-gutter: 20px
  tab-inset: 24px
components:
  toolbar-icon:
    size: 20px
  back-button:
    textColor: "{colors.primary}"
  retry-button:
    backgroundColor: "{colors.control-fill}"
    textColor: "{colors.control-ink}"
  appearance-selected:
    backgroundColor: "{colors.control-fill}"
    textColor: "{colors.control-ink}"
  settings-field:
    backgroundColor: "{colors.low-surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.field}"
  celebration-card:
    backgroundColor: "{colors.low-surface}"
    textColor: "{colors.ink}"
    typography: "{typography.celebration-title}"
    rounded: "{rounded.celebration}"
    padding: "{spacing.celebration-inset}"
  date-navigator:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    rounded: "{rounded.field}"
  reading-row:
    textColor: "{colors.ink}"
    typography: "{typography.title}"
    padding: 7px 4px
  status-panel:
    backgroundColor: "{colors.low-surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.status}"
    padding: "{spacing.status-inset}"
---

# Design System for Lumen Missal

## Overview

**Creative North Star: "Modern utility"**

Neutral chrome keeps daily lookup quick and gives the reading space to breathe. The date navigator and celebration are the strongest visual cues in the index. In the reader, the passage label and citation carry that hierarchy into a simple text column.

**Key characteristics**

- Single-column layout with persistent context.
- Inter headings and comfortably spaced scripture.
- A liturgical accent that follows the selected celebration.

## Colors

Use violet for general actions and the book mark. The first recognised LitCal colour lightly tints the celebration card and supplies the accent for the selected date, reading chevrons, and the open citation. Blend the accent with the theme’s ink to keep it readable. Label every recognised colour option. The card uses the low surface when no recognised colour is available.

## Typography

The bundled Inter family serves headings, controls, and scripture. Use the headline for the passage and settings page titles, the celebration title for the feast name, and the smaller semibold title for controls and reading rows. Set passage text with the scripture style and keep it selectable. Format the date using the current locale.

## Layout

The extension viewport is 420 × 600 px. Use the shared content gutter and scroll the body between the toolbar and the source footer on reading screens. At viewport widths of 520 px and above, center the frame in the tab and cap it at 428 × 640 px. Settings use the same frame and scroll below the toolbar.

## Elevation & Depth

Flat fills and thin dividers establish hierarchy inside the frame. The wider browser-tab presentation lifts the clipped frame over the canvas with Flutter Material elevation 8.

## Shapes

Use compact rounded corners on the date navigator, wordmark, and fields. The status panel, celebration card, and outer tab frame step up in radius as their area increases. Liturgical colours use 10 px outlined swatches with text labels.

## Components

- **Toolbar and footer** keep actions and current calendar and translation in view. Icon actions have tooltips and a brief press-scale response when motion is enabled.
- **Date navigator** provides arrow buttons and a date picker. The Today action returns to the browser’s current date.
- **Celebration card** pairs the feast title with liturgical metadata and labelled colour options.
- **Reading row** pairs a label with its citation and a chevron. Pointer activation opens the reader with a short fade and horizontal slide. Keyboard activation is immediate. Reduced-motion pointer activation uses a short fade. Closing the reader returns focus to its reading row.
- **Passage reader** keeps the return action, label, and citation above a divider. The back action receives focus on entry, and Escape returns to the index.
- **Settings controls** use a segmented appearance selector and full-width outlined dropdowns for translation and calendars.
- **Status panel** pairs an icon with a short heading, an explanation, and a retry button when recovery is available.

## Do's and Don'ts

- **Do** use the same content gutter for the index, reader, settings, and source footer.
- **Do** keep citations visible when passage text is unavailable.
- **Do** use the same liturgical accent across the celebration, date navigator, and reader.
