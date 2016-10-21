module Api
  module V1
    class BucketlistsController < ApplicationController
      respond_to :json

      def create
        user = User.find_by(id: params[:user_id])
        bucketlist = user.bucketlists.build(bucketlist_params)
        return render json: { errors: bucketlist.errors }, status: 422 unless
          bucketlist.save
        render json: bucketlist, status: 201
      end

      def index
        render json: { bucketlists: Bucketlist.all }, status: 200
      end

      def show
        bucketlist = Bucketlist.find_by(id: params[:id])
        render json: bucketlist, status: 200
      end

      private

      def bucketlist_params
        params.require(:bucketlist).permit(:name, :user_id)
      end
    end
  end
end
