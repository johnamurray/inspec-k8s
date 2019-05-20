# frozen_string_literal: true

# K8s Inspec Backend Classes
#
# Based on the GCP Inspec classes
#

require 'json'

# Base class for K8s resources - depends on train K8s transport for connection
class K8sResourceBase < Inspec.resource(1)
  attr_reader :opts, :k8s, :item, :count

  def initialize(opts)
    @opts = opts
    @k8s = inspec.backend
    @count = item.length if item.respond_to? :length
  end

  def failed_resource?
    @failed_resource
  end

  # Intercept K8s client exceptions
  def catch_k8s_errors
    yield
    # create custom messages as needed
  rescue K8s::Error::Conflict => e
    error = JSON.parse(e.body)
    fail_resource error['error']['message']
    @failed_resource = true
    nil
  rescue K8s::Error::NotFound => e
    error = JSON.parse(e.body)
    fail_resource error['error']['message']
    @failed_resource = true
    nil
  rescue Excon::Error::Socket => e
    error = JSON.parse(e.body)
    fail_resource error['error']['message']
    @failed_resource = true
    nil
  end
end
