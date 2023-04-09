//
//  Sentiment.swift
//  APIProject
//
//  Created by cashamirica on 4/9/23.
//

import SwiftUI
import OpenAIKit

final class SentiModel: ObservableObject {
    private var openai: OpenAI?
    
    func setup() {
        openai = OpenAI(Configuration(
            organizationId: "Personal",
            apiKey: "[your api key]"
        ))
    }
    
    func readSentiment(prompt: String) async -> String{
        guard let openai = openai else {
            return ""
        }
        do {
            let parameters = CompletionParameters(model: "text-davinci-003", prompt: ["Decide whether a Tweet's sentiment is positive, neutral, or negative. \n\nTweet: \"\(prompt)\""], maxTokens: 60, temperature: 0, topP: 1.0, presencePenalty: 0.0, frequencyPenalty: 0.5)
            let response = try await openai.generateCompletion(parameters: parameters)
            return String(response.choices.first?.text ?? "No response")
            
        } catch {
            print(error)
        }
        return ""
    }
}

struct Sentiment: View {
    @ObservedObject var sentiModel = SentiModel()
    @State var text = ""
    @State var sentiText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if !sentiText.isEmpty {
                    Text(sentiText)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("Type text to find sentiment")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
                TextField("Type text here...", text: $text)
                    .padding()
                Button("Generate") {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        Task {
                            let result = await sentiModel.readSentiment(prompt: text)
                            if result.isEmpty {
                                print("Failed to read sentiment")
                            }
                            self.sentiText = result
                        }
                    }
                }
            }
            .navigationTitle("Sentiment Reader")
            .onAppear {
                sentiModel.setup()
            }
            .padding()
        }
    }
}

struct Sentiment_Previews: PreviewProvider {
    static var previews: some View {
        Sentiment()
    }
}
