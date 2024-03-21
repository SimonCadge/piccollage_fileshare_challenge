require 'securerandom'

class SharedFilesController < ApplicationController
  before_action :set_shared_file, only: [:show, :update ]
  skip_before_action :require_login, only: [:show ]

  # GET /shared_files
  def index
    @shared_files = SharedFile.all
  end

  # GET /shared_files/1
  def show
  end

  # GET /shared_files/new
  def new
    @shared_file = SharedFile.new
  end

  # POST /shared_files
  def create
    # Get the attached file from the web form
    attached_file = shared_file_params["attached_file"]

    #Generate expiration time, set to 10 minutes in the future by default
    case shared_file_params["link_type"]
    when "short"
      expires_at = Time.now + ENV.fetch("SHORT_LINK_VALID_MINUTES", "10").to_i.minutes
    when "long"
      expires_at = Time.now + ENV.fetch("LONG_LINK_VALID_MINUTES", "60").to_i.minutes
    when "forever"
      expires_at = Float::INFINITY
    end

    @shared_file = SharedFile.new(expires_at: expires_at, user: helpers.current_user)
    @shared_file.attached_file.attach(
      io: attached_file.to_io,
      filename: attached_file.original_filename,
      content_type: attached_file.content_type,
      key: "#{shared_file_params["link_type"]}/#{SecureRandom.uuid}",
      identify: false
    )

    if @shared_file.save
      redirect_to shared_file_url(@shared_file), notice: "Shared file was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /shared_files/1
  def destroy
    @shared_file.destroy!

    redirect_to welcome_index_url, notice: "Shared file was successfully destroyed."
  end

  def update
    if @shared_file.user == helpers.current_user and @shared_file.is_active?
      @shared_file.update(expires_at: Time.now)
    end
    redirect_back(fallback_location: welcome_index_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shared_file
      @shared_file = SharedFile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shared_file_params
      params.require(:shared_file).permit(:attached_file, :link_type)
    end
end
