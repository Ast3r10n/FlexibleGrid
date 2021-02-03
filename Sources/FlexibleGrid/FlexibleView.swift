//
//  FlexibleView.swift
//  
//
//  Created by Andrea Sacerdoti on 03/02/21.
//

import SwiftUI

public struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
  @State var availableWidth: CGFloat
  let data: Data
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content
  @State var elementsSize: [Data.Element: CGSize] = [:]

  public var body: some View {
    ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
      Color.clear
        .frame(height: 1)
        .readSize { size in
          availableWidth = size.width
        }

      VStack(alignment: alignment, spacing: spacing) {
        ForEach(computeRows(), id: \.self) { rowElements in
          HStack(spacing: spacing) {
            ForEach(rowElements, id: \.self) { element in
              content(element)
                .fixedSize()
                .readSize { size in
                  elementsSize[element] = size
                }
            }
          }
        }
      }
    }
  }

  private func computeRows() -> [[Data.Element]] {
    var rows: [[Data.Element]] = [[]]
    var currentRow = 0
    var remainingWidth = availableWidth

    data.forEach { element in
      let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

      if remainingWidth - (elementSize.width + spacing) >= 0 {
        rows[currentRow].append(element)
      } else {
        currentRow = currentRow + 1
        rows.append([element])
        remainingWidth = availableWidth
      }

      remainingWidth -= elementSize.width + spacing
    }

    return rows
  }
}
