//
//  FlexibleGrid.swift
//  
//
//  Created by Andrea Sacerdoti on 03/02/21.
//

import SwiftUI

public struct FlexibleGrid<Data: Collection, Content: View>: View where Data.Element: Hashable {
  @State private var availableWidth: CGFloat = 0
  public let data: Data
  public let spacing: CGFloat
  public let alignment: HorizontalAlignment
  public let content: (Data.Element) -> Content
  @State public var elementsSize: [Data.Element: CGSize] = [:]

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

  public init(_ data: Data,
              spacing: CGFloat = 8,
              alignment: HorizontalAlignment = .leading,
              @ViewBuilder _ content: @escaping (Data.Element) -> Content) {
    self.data = data
    self.spacing = spacing
    self.alignment = alignment
    self.content = content
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
