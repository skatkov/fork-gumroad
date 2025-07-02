# frozen_string_literal: true

class Admin::SearchController < Admin::BaseController
  include Pagy::Backend

  before_action :clean_search_query

  RECORDS_PER_PAGE = 25
  private_constant :RECORDS_PER_PAGE

  def users
    @title = "User results"

    @users = User.where(email: @raw_query).order("created_at DESC").limit(25) if @raw_query.match(User::EMAIL_REGEX)
    @users ||= User.where("external_id = ? or email like ? or name like ?",
                          @raw_query, @query, @query).order("created_at DESC").limit(RECORDS_PER_PAGE)

    redirect_to admin_user_path(@users.first) if @users.length == 1
  end

  def purchases
    @title = "Purchase results"

    @purchases = AdminSearchService.new.search_purchases(query: @raw_query)
    @pagination, @purchases = pagy(@purchases, page: params[:page], limit: RECORDS_PER_PAGE) if @purchases.present?

    redirect_to admin_purchase_path(@purchases.first) if @purchases.one? && params[:page].blank?
  end

  private
    def clean_search_query
      @raw_query = params[:query].strip
      @query = "%#{@raw_query}%"
    end

    def set_title
      @title = "Search for #{@raw_query}"
    end
end
