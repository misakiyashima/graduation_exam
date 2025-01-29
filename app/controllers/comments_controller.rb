class CommentsController < ApplicationController
  def create
    # ホテル情報をAPIから取得
    client = HotelService.new(ENV['RAKUTEN_API_KEY'])  # 'YOUR_API_KEY'を実際のAPIキーに置き換えてください
    hotel_info = client.get_hotel_details(params[:hotel_id], fields: ['hotelName', 'hotelImageUrl', 'hotelInformationUrl', 'hotelSpecial'])

    if hotel_info.nil?
      flash[:alert] = "ホテルが見つかりませんでした。"
      redirect_to hotels_path
      return
    end

    # ホテルが存在するか確認し、存在しない場合は新規作成
    @hotel = Hotel.find_or_create_by(id: params[:hotel_id]) do |hotel|
      hotel.name = hotel_info['hotelName']
      hotel.hotel_information_url = hotel_info['hotelInformationUrl']
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

  def comment_params
    params.require(:comment).permit(:body)
  end
end
