import Foundation
import PackagePlugin

@main
struct SourceryBuildToolPlugin: BuildToolPlugin {
    struct Template {
        let name: String
        let content: String
    }

    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {

        let sourcery = try context.tool(named: "sourcery")
        let fileManager = FileManager.default

        // Possible paths where there may be a config file,
        // Only one will be used, they are tried in order.
        let paths = [
            target.directory.appending("sourcery.yml"),
            context.package.directory.appending("sourcery.yml"),
        ]

        let templatesDirectory = context.pluginWorkDirectory.appending(subpath: "templates")

        var commands = [Command]()

        for configuration in paths {
            guard fileManager.fileExists(atPath: configuration.string) else {
                print("ℹ️ File don't exist at path", "", configuration.string )
                break
            }

            print("▶️ found configuration at path", "", configuration.string )

            let outputPath = context.pluginWorkDirectory.appending(subpath: target.name)
            let resultPath = outputPath.appending("generated")
            let cachePath = outputPath.appending("cache")

            let env = [
                "TARGET_NAME": target.name,
                "TARGET_DIR": target.directory,
                "PROJECT_DIR": context.package.directory,
                "TEMPLATES_DIR": templatesDirectory,
                "DERIVED_SOURCES_DIR": "\(resultPath)",
            ] as [String: CustomStringConvertible]

            let args = [
                "--verbose",
                "--config", "\(configuration)",
                "--cacheBasePath", cachePath.string,
            ]

            print("🏗️", outputPath.string)

            commands.append(
                .prebuildCommand(
                    displayName: "Sourcery BuildTool Plugin",
                    executable: sourcery.path,
                    arguments: args,
                    environment: env,
                    outputFilesDirectory: resultPath
                )
            )
        }

        // Save templates if we've got commands to run
        if !commands.isEmpty {
            try fileManager.createDirectory(atPath: templatesDirectory.string, withIntermediateDirectories: true)
            for template in [AutoEquatable, AutoHashable, AutoMockable] {
                let path = templatesDirectory.appending(subpath: "\(template.name).stencil")
                fileManager.createFile(
                    atPath: path.string,
                    contents: Data(template.content.utf8)
                )
            }
        }

        return commands
    }

    let test = ""
}
