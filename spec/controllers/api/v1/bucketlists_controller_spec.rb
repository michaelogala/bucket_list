require 'rails_helper'

RSpec.describe Api::V1::BucketlistsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }
    let(:bucketlist_attr){ attributes_for :bucketlist, user: user }
    let!(:initial_bucketlist_count) { Bucketlist.count }

    context 'with valid params' do

      before { post :create, user_id: user.id, bucketlist: bucketlist_attr }

      it 'persists bucketlist to database' do
        expect(Bucketlist.count).to eq initial_bucketlist_count + 1
      end

      it 'returns a json response containing the recently created object' do
        bucketlist_response = json_response
        expect(bucketlist_response[:name]).to eq bucketlist_attr[:name]
      end

      it 'has a response status indicating success' do
        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      before { post :create, user_id: user.id, bucketlist: { name: nil } }

      it 'does not persist to the databse' do
        expect(Bucketlist.count).to eq initial_bucketlist_count
      end

      it 'returns an error json' do
        bucketlist_response = json_response
        expect(bucketlist_response[:errors]).to be_present
      end

      it 'has a response status indicating failure' do
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET #index' do
    let!(:bucketlists) { create_list :bucketlist, 20 }
    before { get :index }

    it 'returns all bucketlists' do
      bucketlist_response = json_response
      expect(bucketlist_response[:bucketlists].size).to eq bucketlists.size
    end

    it 'return a success status code' do
      expect(response.status).to eq 200
    end
  end
end