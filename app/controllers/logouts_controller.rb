  def destroy
    logout
    redirect_to root_path, status: :see_other
  end