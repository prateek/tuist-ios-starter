import ProjectDescription

let tuist = Tuist(
    fullHandle: "prungta2/iOSClaudeCodeStarter",
    generationOptions: .options(
        // Don't fail or try uploading run metadata if CI isn't authenticated
        optionalAuthentication: true,
        // Avoid the sandbox that blocks /Applications/Xcode.app
        disableSandbox: true
    )
)
