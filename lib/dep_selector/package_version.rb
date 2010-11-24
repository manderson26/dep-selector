require 'rubygems'
require 'gecoder'

module DepSelector
  class PackageVersion
    attr_accessor :package, :version, :dependencies

    def initialize(package, version)
      @package = package
      @version = version
      @dependencies = []
    end

    def generate_gecode_constraints
      pkg_mv = package.gecode_model_var
      pkg_densely_packed_version = package.densely_packed_versions["= #{version}"].first

      guard = (pkg_mv.must == pkg_densely_packed_version)
      conjunction = dependencies.inject(guard){ |acc, dep| acc & dep.generate_gecode_constraint }
      conjunction | (pkg_mv.must_not == pkg_densely_packed_version)
    end
  end
end