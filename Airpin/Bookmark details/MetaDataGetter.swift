//
//  MetaDataGetter.swift
//  Airpin
//
//  Created by Thomas Carey on 1/28/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import SwiftSoup

class MetaDataGetter: NSObject, URLSessionDataDelegate {

    private let url: URL
    private let completionHandler: ((_ title: String, _ description: String) -> Void)?

    private var header: String = ""

    init(url: URL, completionHandler: ((_ title: String, _ description: String) -> Void)?) {
        self.url = url
        self.completionHandler = completionHandler
        super.init()
    }

    func resume() {
        retrieveMetadata(for: url)
    }

    private func retrieveMetadata(for url: URL) {
        let request = URLRequest(url: url)
        let con = URLSessionConfiguration.default
        let session = URLSession(configuration: con, delegate: self, delegateQueue: nil)
        let dt = session.dataTask(with: request)
        dt.resume()
    }

    private func retrieveOpenGraphValues(for content: String) {
        do {
            if let head = try SwiftSoup.parse(content).head() {
                let title = try getTitleByTraditionalMeans(head) ?? getTitleFromOpenGraph(head) ?? ""
                let description = try getDescriptionByTraditionalMeans(head) ?? getDescriptionFromOpenGraph(head) ?? ""

                completionHandler?(title, description)
            }
        } catch Exception.Error(let type, let message) {
            print("Exception occurred. Type = \(type), message = \(message)")
        } catch {
            print(error)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard dataTask.state != .canceling else { return }

        if let content = String(data: data, encoding: .utf8) {
            header.append(content)
        }

        if header.lowercased().contains("</head>") {
            dataTask.cancel()
            retrieveOpenGraphValues(for: header)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {}

    private func getTitleByTraditionalMeans(_ head: Element) throws -> String? {
        return try head.getElementsByAttributeValue("name", "title").array().first?.attr("content")
    }

    private func getTitleFromOpenGraph(_ head: Element) throws -> String? {
        return try head.getElementsByAttributeValue("property", "og:title").array().first?.attr("content")
    }

    private func getDescriptionByTraditionalMeans(_ head: Element) throws -> String? {
        return try head.getElementsByAttributeValue("name", "description").array().first?.attr("content")
    }

    private func getDescriptionFromOpenGraph(_ head: Element) throws -> String? {
        return try head.getElementsByAttributeValue("property", "og:description").array().first?.attr("content")
    }
}
