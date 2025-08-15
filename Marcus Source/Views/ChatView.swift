import SwiftUI

struct ChatView: View {
    @EnvironmentObject var app: AppState
    let challenge: Challenge
    @State private var text: String = ""
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(app.messagesFor(challengeId: challenge.id)) { m in
                            ChatBubble(message: m, isMe: m.userId == app.currentUser.id).id(m.id)
                        }
                    }.padding()
                }.onChange(of: app.messages.count) { _ in if let last = app.messages.last { proxy.scrollTo(last.id, anchor: .bottom) } }
            }
            HStack {
                TextField("Message…", text: $text).textFieldStyle(.roundedBorder)
                Button { guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }; app.addMessage(text, challengeId: challenge.id); text = "" } label: { Image(systemName: "paperplane.fill") }.buttonStyle(.borderedProminent)
            }.padding().background(.ultraThinMaterial)
        }.navigationTitle("Chat")
    }
}

struct ChatBubble: View {
    @EnvironmentObject var app: AppState
    let message: Message
    let isMe: Bool
    var body: some View {
        HStack {
            if isMe { Spacer() }
            VStack(alignment: .leading, spacing: 4) {
                if !isMe, let u = app.users.first(where: {$0.id == message.userId}) {
                    HStack(spacing: 6) { AvatarView(user: u).frame(width: 24, height: 24); Text(u.name).font(.caption).foregroundColor(.secondary) }
                }
                Text(message.text).padding(10).background(RoundedRectangle(cornerRadius: 12).fill(isMe ? Color.accentColor : Color(.secondarySystemBackground))).foregroundColor(isMe ? .white : .primary)
            }
            if !isMe { Spacer() }
        }
    }
}
