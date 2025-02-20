class CommentsController < ApplicationController
  before_action :set_hotel, only: [:create]
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    # ホテル情報をAPIから取得
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])
    hotel_info = client.get_hotel_details(params[:hotel_id], fields: ['hotelName', 'hotelImageUrl', 'hotelInformationUrl', 'hotelSpecial'])

    if hotel_info.nil?
      flash[:alert] = "ホテルが見つかりませんでした。"
      redirect_to hotels_path
      return
    end

    # コメントを作成
    @comment = @hotel.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to hotel_path(@hotel), notice: 'コメントが投稿されました。'
    else
      redirect_to hotel_path(@hotel), alert: 'コメントの投稿に失敗しました。'
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
