require 'rails_helper'

RSpec.describe VoteMailer, type: :mailer do
  let(:movie_creator) { double(name: 'Movie creator', email: 'movie_creator@example.com') }
  let(:movie)         { double(title: 'Test movie', user: movie_creator) }
  let(:user)          { double(name: 'Test Dummy', email: 'test@example.com') }
  let(:action)        { :like }
  let(:email_params)  { { 'user' => user, 'movie' => movie, 'action' => action } }
  let!(:mailer)       { VoteMailer.notify_movie_creator(email_params) }

  describe '#notify_movie_creator' do
    it 'sets the mailer subject correctly' do
      expect(mailer.subject).to eq('Test Dummy has liked your movie!')
    end

    it 'sets the mailer from address correctly' do
      expect(mailer.from[0]).to eq('from@example.com')
    end

    it 'sets the mailer to address correctly' do
      expect(mailer.to[0]).to eq('movie_creator@example.com')
    end

    it 'sets the mailer to body text correctly' do
      expect(mailer.body.encoded).to match("#{user.name} has #{action}d your movie #{movie.title}!")
    end
  end
end
