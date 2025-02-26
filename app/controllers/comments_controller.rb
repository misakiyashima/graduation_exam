class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :set_hotel, only: [:create, :destroy]

  def create
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])
    hotel_info = client.get_hotel_details(params[:hotel_id], fields: ['hotelName', 'hotelImageUrl', 'hotelInformationUrl', 'hotelSpecial'])

    if hotel_info.nil?
      flash[:alert] = "ホテルが見つかりませんでした。"
      redirect_to hotels_path
      return
    end

    @comment = @hotel.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to hotel_path(@hotel), notice: 'コメントが投稿されました。'
    else
      redirect_to hotel_path(@hotel), alert: 'コメントの投稿に失敗しました。'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to hotel_path(@hotel), notice: 'コメントが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    redirect_to hotel_path(@hotel), notice: 'コメントが削除されました。'
  end

  private

  def set_hotel
    @hotel = @comment.hotel
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
