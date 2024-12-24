//
//  TextboxView.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//


import SwiftUI

struct TextboxView: View {
    let placeholder: String
    @Binding var text: String
    var keyBoardType: UIKeyboardType = .default
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            // Placeholder
            Text(placeholder)
                .foregroundColor(isFocused || !text.isEmpty ? .gray : .white.opacity(0.6))
                .font(.system(size: 16, weight: .medium))
                .offset(y: isFocused || !text.isEmpty ? -24 : 0)
                .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1, anchor: .leading)
                .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)

            // Text Field
            TextField("", text: $text)
                .keyboardType(keyBoardType)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.top, isFocused || !text.isEmpty ? 18 : 0)
                .focused($isFocused)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? Color.blue : Color.gray.opacity(0.8), lineWidth: 1)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        )
        .frame(height: 56)
    }
}
