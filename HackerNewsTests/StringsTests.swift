//
//  StringsTests.swift
//  HackerNewsTests
//
//  Created by Konstantinos Kolioulis on 1/10/25.
//

import Testing
@testable import HackerNews

struct StringsTests {
    
    @Test func `extract domain from valid URL without www`() async throws {
        let urlString = "https://example.com/path/to/page"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `extract domain from valid URL with www`() async throws {
        let urlString = "https://www.example.com/path/to/page"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `extract domain from URL with subdomain`() async throws {
        let urlString = "https://api.example.com/endpoint"
        #expect(urlString.domainUrl == "api.example.com")
    }
    
    @Test func `extract domain from URL with www and subdomain`() async throws {
        let urlString = "https://www.api.example.com/endpoint"
        #expect(urlString.domainUrl == "api.example.com")
    }
    
    @Test func `extract domain from simple URL without path`() async throws {
        let urlString = "https://example.com"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `extract domain from URL with port`() async throws {
        let urlString = "https://www.example.com:8080/path"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `extract domain from URL with query parameters`() async throws {
        let urlString = "https://www.example.com/search?q=test&lang=en"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `return nil for invalid URL string`() async throws {
        let urlString = "not a valid url"
        #expect(urlString.domainUrl == nil)
    }
    
    @Test func `return nil for empty string`() async throws {
        let urlString = ""
        #expect(urlString.domainUrl == nil)
    }
    
    @Test func `return nil for URL without host`() async throws {
        let urlString = "file:///path/to/file"
        #expect(urlString.domainUrl == nil)
    }
    
    @Test func `handle URL with multiple www prefixes`() async throws {
        let urlString = "https://www.www.example.com"
        #expect(urlString.domainUrl == "www.example.com")
    }
    
    @Test func `extract domain from HTTP URL`() async throws {
        let urlString = "http://www.example.com/page"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `extract domain from URL with fragment`() async throws {
        let urlString = "https://www.example.com/page#section"
        #expect(urlString.domainUrl == "example.com")
    }
    
    @Test func `extract domain from complex URL`() async throws {
        let urlString = "https://www.subdomain.example.co.uk:443/path/to/resource?param=value#anchor"
        #expect(urlString.domainUrl == "subdomain.example.co.uk")
    }
}
