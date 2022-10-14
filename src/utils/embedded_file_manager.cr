module EmbeddedFileManager
  macro cluster_tools
    CLUSTER_TOOLS = ENV["USE_MANIFEST_FOR_SPECS"]? ? File.read("./tools/cluster-tools/manifest.yml") : File.read("./lib/cluster_tools/tools/cluster-tools/manifest.yml")
  end
end
