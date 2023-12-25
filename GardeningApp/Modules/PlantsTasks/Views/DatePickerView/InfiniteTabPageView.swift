//
//
// GardeningApp
// GreetingsView.swift
//
// Created by Alexander Kist on 12.12.2023.
//
// https://gist.github.com/beader/e1312aa5b88af30407bde407235fbe67

import SwiftUI

struct InfiniteTabPageView<Content: View>: View {
    @GestureState private var translation: CGFloat = .zero
    @Binding var currentPage: Int
    @State private var offset: CGFloat = .zero

    private let width: CGFloat
    private let animationDuration: CGFloat = 0.25
    let content: (_ page: Int) -> Content

    init(
        width: CGFloat = 390,
        page: Binding<Int>,
        @ViewBuilder content: @escaping (_ page: Int) -> Content
    ) {
        self.width = width
        self._currentPage = page
        self.content = content
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($translation) { value, state, _ in
                let translation = min(width, max(-width, value.translation.width))
                state = translation
            }
            .onEnded { value in
                offset = min(width, max(-width, value.translation.width))
                let predictEndOffset = value.predictedEndTranslation.width
                withAnimation(.easeOut(duration: animationDuration)) {
                    if offset < -width / 2 || predictEndOffset < -width {
                        offset = -width
                    } else if offset > width / 2 || predictEndOffset > width {
                        offset = width
                    } else {
                        offset = 0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    if offset < 0 {
                        currentPage += 1
                    } else if offset > 0 {
                        currentPage -= 1
                    }
                    offset = 0
                }
            }
    }

    var body: some View {
        ZStack {
            content(pageIndex(currentPage + 2) - 1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(1 - offsetIndex(currentPage - 1)) * width)

            content(pageIndex(currentPage + 1) + 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(1 - offsetIndex(currentPage + 1)) * width)

            content(pageIndex(currentPage + 0) + 1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: CGFloat(1 - offsetIndex(currentPage)) * width)
        }
        .contentShape(Rectangle())
        .offset(x: translation)
        .offset(x: offset)
        .gesture(dragGesture)
        .clipped()
    }

    private func pageIndex(_ x: Int) -> Int {
        // 0 0 0 3 3 3 6 6 6 . . . 周期函数
        // 用来决定 3 个 content 分别应该展示第几页
        Int((CGFloat(x) / 3).rounded(.down)) * 3
    }


    private func offsetIndex(_ x: Int) -> Int {
        // 0 1 2 0 1 2 0 1 2 ... 周期函数
        // 用来决定静止状态 3 个 content 的摆放顺序
        if x >= 0 {
            return x % 3
        } else {
            return (x + 1) % 3 + 2
        }
    }
}

