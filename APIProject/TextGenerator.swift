//
//  TextGenerator.swift
//  APIProject
//
//  Created by cashamirica on 4/9/23.
//

import OpenAIKit
import SwiftUI

final class ChatModel: ObservableObject {
    private var openai: OpenAI?
    
    func setup() {
        openai = OpenAI(Configuration(
                    organizationId: "Personal",
                    apiKey: "[your api key]"
                ))
    }
    
    func generateText(prompt: String) async -> String? {
        guard let openai = openai else {
            return nil
        }
        
        do {
            //let parameters = Completion
            let parameters = CompletionParameters(model: "text-davinci-002", prompt: [prompt], maxTokens: 50, temperature: 0.5, stop:["\n"])
            
            let response = try await openai.generateCompletion(parameters: parameters)
            
            guard let text = response.choices.first?.text else {
                return nil
            }
            
            return text
        } catch {
            print(String(describing: error))
            return nil
        }
    }
}

struct TextGenerator: View {
    @ObservedObject var chatModel = ChatModel()
    @State var text = ""
    @State var generatedText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if !generatedText.isEmpty {
                    Text(generatedText)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("Type prompt to generate text")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
                TextField("Type prompt here...", text: $text)
                    .padding()
                Button("Generate") {
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        Task {
                            let result = await chatModel.generateText(prompt: text)
                            //print(result ?? "fail")
                            if result == nil {
                                print("Failed to generate text")
                            }
                            self.generatedText = result ?? ""
                        }
                    }
                }
            }
            .navigationTitle("Text Generator")
            .onAppear {
                chatModel.setup()
            }
            .padding()
        }
    }
}

struct TextGenerator_Previews: PreviewProvider {
    static var previews: some View {
        TextGenerator()
    }
}
