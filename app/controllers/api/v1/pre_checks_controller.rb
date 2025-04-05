class Api::V1::PreChecksController < ApplicationController
  before_action :allow_driver_only, only: [:create, :update]

  def create
    
  end

  def update

  end
end