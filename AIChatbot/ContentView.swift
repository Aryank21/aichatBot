//
//  ContentView.swift
//  AIChatbot
//
//  Created by Aryan iOS on 07/04/26.
//

import SwiftUI

struct ChatItem: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let time: String
}
struct TypingIndicator: View {
    @State private var dots = 0
    
    var body: some View {
        HStack {
            Text("Typing" + String(repeating: ".", count: dots))
                .padding(10)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                dots = (dots + 1) % 4
            }
        }
    }
}
struct ChatBubble: View {
    let message: ChatItem

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                
                Text(message.text)
                    .padding(12)
                    .foregroundColor(message.isUser ? .white : .black)
                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.3))
                    .cornerRadius(16)
                
                Text(message.time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}
struct ContentView: View {
    
    @State private var text: String = ""
    @State private var chatList: [ChatItem] = []
    @State private var isTyping: Bool = false
    
    let service = NetworkManager()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // ✅ Chat Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        
                        ForEach(chatList) { item in
                            ChatBubble(message: item)
                                .id(item.id)
                        }
                        
                        if isTyping {
                            TypingIndicator()
                        }
                    }
                    .padding(.top)
                }
                .background(Color(.systemGroupedBackground))
                .onChange(of: chatList.count) { _, _ in
                    scrollToBottom(proxy)
                }
                .onChange(of: isTyping) { _, _ in
                    scrollToBottom(proxy)
                }
            }
            
            Divider()
            
            // ✅ Input Bar
            HStack {
                TextField("Message...", text: $text)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color.white)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // ✅ keyboard fix
    }
    
    // ✅ Send Message
    func sendMessage() {
        guard !text.isEmpty else { return }
        
        let userMsg = ChatItem(
            text: text,
            isUser: true,
            time: currentTime()
        )
        
        chatList.append(userMsg)
        
        let input = text
        text = ""
        
        isTyping = true
        
        service.sendMessage(message: input) { response in
            isTyping = false
            
            let botMsg = ChatItem(
                text: response,
                isUser: false,
                time: currentTime()
            )
            
            chatList.append(botMsg)
        }
    }
    
    // ✅ Scroll Helper
    func scrollToBottom(_ proxy: ScrollViewProxy) {
        if let last = chatList.last {
            DispatchQueue.main.async {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
    
    // ✅ Time Formatter
    func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

#Preview {
    ContentView()
}
