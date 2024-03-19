class SharedFilesController < ApplicationController
  before_action :set_shared_file, only: [:show, :update ]
  skip_before_action :require_login, only: [:show ]

  # GET /shared_files or /shared_files.json
  def index
    @shared_files = SharedFile.all
  end

  # GET /shared_files/1 or /shared_files/1.json
  def show
  end

  # GET /shared_files/new
  def new
    @shared_file = SharedFile.new
  end

  # POST /shared_files or /shared_files.json
  def create
    # Get the attached file from the web form
    attached_file = shared_file_params["attached_file"]

    #Generate expiration time, set to 10 minutes in the future by default
    expires_at = Time.now + ENV.fetch("LINK_VALID_MINUTES", "10").to_i.minutes

    @shared_file = SharedFile.new(expires_at: expires_at, attached_file: attached_file, user: helpers.current_user)

    respond_to do |format|
      if @shared_file.save
        format.html { redirect_to shared_file_url(@shared_file), notice: "Shared file was successfully created." }
        format.json { render :show, status: :created, location: @shared_file }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shared_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shared_files/1 or /shared_files/1.json
  def destroy
    @shared_file.destroy!

    respond_to do |format|
      format.html { redirect_to welcome_index_url, notice: "Shared file was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update
    if @shared_file.user == helpers.current_user and @shared_file.expires_at >= Time.now
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
      params.require(:shared_file).permit(:attached_file)
    end
end
