class VoteMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify_movie_creator(args)
    @user = args.fetch('user').name
    @movie = args.fetch('movie')
    @movie_creator = @movie.user.name
    to = @movie.user.email
    @action = determine_subject(args.fetch('action'))
    mail(to: to, subject: "#{@user} has #{@action} your movie!")
  end

  def determine_subject(action)
    case action
    when :like then 'liked'
    when :hate then 'hated'
    else raise
    end
  end

end
