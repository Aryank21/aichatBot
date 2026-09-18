# 🤖 AI Chatbot — iOS

A general-purpose conversational AI assistant for iOS, built with **Swift** and powered by the **Grok API (xAI)**. Ask it anything — it holds context across turns like a mini ChatGPT, natively on iOS.

---

## 📱 Screenshot

<p align="center">
  <img src="https://private-user-images.githubusercontent.com/105555664/653800025-acd12c99-d7f0-434c-99cc-6b2ee8fcf8cf.png" width="300" />
</p>

---

## ✨ Features

- Natural language Q&A — ask general questions and get conversational responses
- **Multi-turn conversational memory** — keeps a rolling window of recent messages so follow-up questions stay coherent without the user having to repeat context
- Clean native chat UI built with UIKit (message bubbles, input bar, scroll-to-latest)
- Integrates directly with the **Grok API (xAI)** over REST

---

## 🛠️ Tech Stack

`Swift` · `UIKit` · `URLSession` · `Grok API (xAI)` · `JSON`

---

## 🧠 How it works

1. User sends a message from the chat UI
2. The app appends it to a rolling conversation history (last N message pairs)
3. The full history is sent to the Grok API as context, so the model's responses stay coherent across turns
4. The response streams/returns and renders as a new message bubble

*(Add a short code snippet here — the function that builds the message history array and calls the API is worth more to a reviewer than any prose description.)*

---

## 🚧 Status

Personal project — built to get hands-on with LLM integration on iOS. This experience directly informed the AI assistant feature I later shipped in production inside CricDaddy.

---

## 📫 Contact

[Portfolio](https://profolio-aryan.vercel.app/) · [LinkedIn](https://linkedin.com/in/aryankumar99) · aryanbgp9798@gmail.com
