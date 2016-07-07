require 'rails_helper'

RSpec.describe VotingBooth do
  before do
    @alice = User.create(
      uid:  'null|12345',
      name: 'Alice'
    )
    @bob = User.create(
      uid:  'null|67890',
      name: 'Bob'
    )
    @movie = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         @alice,
      liker_count:  50,
      hater_count:  2
    )
  end

  subject { VotingBooth.new(@bob, @movie) }

  before do
    allow(subject).to receive(:_email_movie_creator)
  end

  it 'updates the vote counts' do
    expect(subject).to receive(:_update_counts).twice
    subject.vote(:like)
  end

  it 'updates the movie like and hate counts' do
    expect(@movie).to receive(:update).twice
    subject.vote(:like)
  end

  it 'calls unvote to guarantee vote consistency every time' do
    allow(@movie).to receive(:update)
    expect(subject).to receive(:unvote).once
    subject.vote(:like)
  end

  it 'increments the vote count when liked' do
    subject.vote(:like)
    expect(@movie.likers.count).to eq(1)
  end

  it 'only allows a user to vote once on a movie' do
    subject.vote(:like)
    subject.vote(:hate)
    expect(@movie.likers.count).to eq(0)
    expect(@movie.haters.count).to eq(1)
  end
end
