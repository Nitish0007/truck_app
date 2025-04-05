class Api::V1::DocumentsController < ApplicationController
  before_action :allow_driver_only, only: [:create, :update, :destroy, :get_upload_url]

  def get_upload_url
    return render json: { errors: "File size should not be more than 5 MBs" }, status: :unprocessable_entity if params[:byte_size] > 5.megabytes # ---> 5 * 1024 * 1024 = 5_242_880 bytes
    begin
      result = Document.generate_pre_signed_upload_url(params[:byte_size], params[:content_type], params[:file_name], params[:checksum])
      render json: { upload_url: result[0], signed_id:  result[1]}, status: :ok
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  def get_download_url
    doc = Document.find_by(id: params[:id])
    if doc.nil? || !doc.file.attached?
      return render json: { errors: "Document not found or has no file attached" }, status: :not_found
    end
    render json: { download_url: doc.file_url }, status: :ok
  end

  # create record in document table and associate it with the other entities
  def create
    begin
      document = Document.new(document_params)
      if params[:document][:signed_id].present?
        document.file.attach(params[:document][:signed_id])
      end
      if document.save
        render json: { message: "Document uploaded successfully!" }, status: :ok
      else
        render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  def update
    begin
      doc = Document.find_by_id(params[:id])
      if doc.nil?
        return render json: { errors: "Document not found" }, status: :not_found
      end
      if document.save
        render json: { message: "Document updated successfully!" }, status: :ok
      else
        render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  def destroy
    doc = Document.find_by_id(params[:id])
    if doc.nil?
      return render json: { errors: "Document not found or has no file attached" }, status: :not_found
    end
    if doc.file.purge
      render json: { message: "Document deleted successfully!" }, status: :ok
    else
      render json: { errors: "Unable to delete the document" }, status: :unprocessable_entity
    end
  end

  private
  def document_params
    params.require(:document).permit(:user_id, :ride_id, :truck_id, :worksheet_id, :source_class, :document_type)
  end

end