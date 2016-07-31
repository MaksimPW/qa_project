RSpec.shared_examples_for 'voted' do
  describe 'PATCH #vote_up' do
    sign_in_user
    let(:user_object) { create(described_class.controller_name.classify.constantize, user: @user) }
    let(:object) { create(described_class.controller_name.classify.constantize) }

    it 'assigns the requested object to @votable_object' do
      patch :vote_up, id: object.id, format: :json
      expect(assigns(:votable_object)).to eq object
    end

    it 'render json' do
      patch :vote_up, id: object, format: :json
      json = %({"object": #{object.id},
                "score": 1,
                "button_vote": "up",
                "kontroller": "#{described_class.controller_name.classify.constantize}"}
              )

      expect(response.body).to be_json_eql json
    end

    it 'can vote up for votable' do
      expect { patch :vote_up, id: object.id, format: :json }.to change(object.votes, :count).by(1)
    end

    it 'change votable score before vote up' do
      patch :vote_up, id: object.id, format: :json
      object.reload
      expect(object.score).to eq 1
    end

    it 'can vote only once' do
      expect { patch :vote_up, id: object.id, format: :json }.to change(object.votes, :count).by(1)
      expect { patch :vote_up, id: object.id, format: :json }.not_to change(object.votes, :count)
    end

    it 'can`t vote up for own votable' do
      expect { patch :vote_up, id: user_object, format: :json }.to_not change(user_object.votes, :count)
    end

    it 'render json error if vote own record' do
      patch :vote_up, id: user_object, format: :json
      json = %({"errors": "You can`t vote own record"})
      expect(response.body).to be_json_eql json
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user
    let(:user_object) { create(described_class.controller_name.classify.constantize, user: @user) }
    let(:object) { create(described_class.controller_name.classify.constantize) }

    it 'assigns the requested object to @votable_object' do
      patch :vote_down, id: object.id, format: :json
      expect(assigns(:votable_object)).to eq object
    end

    it 'render json' do
      patch :vote_down, id: object.id, format: :json
      json = %({"object": #{object.id},
                "score": -1,
                "button_vote": "down",
                "kontroller": "#{described_class.controller_name.classify.constantize}"}
              )

      expect(response.body).to be_json_eql json
    end

    it 'can vote up for votable' do
      expect { patch :vote_down, id: object.id, format: :json }.to change(object.votes, :count).by(1)
    end

    it 'change votable score before vote up' do
      patch :vote_down, id: object.id, format: :json
      object.reload
      expect(object.score).to eq -1
    end

    it 'can vote only once' do
      expect { patch :vote_down, id: object.id, format: :json }.to change(object.votes, :count).by(1)
      expect { patch :vote_down, id: object.id, format: :json }.not_to change(object.votes, :count)
    end

    it 'can`t vote up for own votable' do
      expect { patch :vote_down, id: user_object, format: :json }.to_not change(user_object.votes, :count)
    end

    it 'render json error if vote own record' do
      patch :vote_down, id: user_object, format: :json
      json = %({"errors": "You can`t vote own record"})
      expect(response.body).to be_json_eql json
    end
  end

  describe 'DELETE #vote_destroy' do
    sign_in_user
    let(:user_object) { create(described_class.controller_name.classify.constantize, user: @user) }
    let(:object) { create(described_class.controller_name.classify.constantize) }

    before { patch :vote_up, id: object.id, format: :json }

    it 'render json' do
      delete :vote_destroy, id: object.id, format: :json
      json = %({"object": #{object.id},
                "score": 0,
                "button_vote": "destroy",
                "kontroller": "#{described_class.controller_name.classify.constantize}"}
              )

      expect(response.body).to be_json_eql json
    end

    it 'can vote destroy' do
      expect { delete :vote_destroy, id: object.id, format: :json }.to change(object.votes, :count).by(-1)
    end

    it 'change votable score before vote destroy' do
      delete :vote_destroy, id: object.id, format: :json
      object.reload
      expect(object.score).to eq 0
    end

    it 'render json error if error' do
       delete :vote_destroy, id: object.id, format: :json
       delete :vote_destroy, id: object.id, format: :json
       json = %({"errors": "Not found"})
       expect(response.body).to be_json_eql json
    end
  end
end