require "log"
require "./spec_helper"
require "../cluster_tools.cr"

describe "ClusterTools" do
  before_all do
    begin
      KubectlClient::Apply.namespace(ClusterTools.namespace)
      Log.info { "#{ClusterTools.namespace} namespace created" }
    rescue e : KubectlClient::ShellCMD::AlreadyExistsError
      Log.info { "#{ClusterTools.namespace} namespace already exists on the Kubernetes cluster" }
    end
  end
  after_all do
    ClusterTools.uninstall
  end

  describe "pre install" do
    it "ensure_namespace_exists!" do
      (ClusterTools.ensure_namespace_exists!).should be_true

      KubectlClient::Delete.resource("namespace", "#{ClusterTools.namespace}")

      expect_raises(ClusterTools::NamespaceDoesNotExistException, "ClusterTools Namespace #{ClusterTools.namespace} does not exist") do
        ClusterTools.ensure_namespace_exists!
      end
    end

    it "install" do
      KubectlClient::Apply.namespace(ClusterTools.namespace)

      (ClusterTools.install).should be_true

      (ClusterTools.ensure_namespace_exists!).should be_true
    end
  end

  describe "post install" do
    before_all do
      ClusterTools.install
    end
    it "ensure_namespace_exists!" do
      (ClusterTools.ensure_namespace_exists!).should be_true
    end

    it "pod_name" do
      (/cluster-tools/ =~ ClusterTools.pod_name).should_not be_nil
    end
  end
end
