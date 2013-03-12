class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/first/M
  # GET /cards/first/M.json
  def first
    @cards = Card.where(:first => params[:first])

    respond_to do |format|
      format.html #first.html.erb
      format.json { render json: @cards }
    end
  end

  # GET /cards/last/M
  # GET /cards/last/M.json
  def last 
    @cards = Card.where(:last => params[:last])

    respond_to do |format|
      format.html #first.html.erb
      format.json { render json: @cards }
    end
  end

  # GET /cards/random/N
  # GET /cards/random/N.json
  def random 
    if params[:random]
      @card = Card.where(:first => params[:random]).sample
    else
      # @card = Card.all.sample
      rand_id = rand(Card.count)
      @card = Card.first(:conditions => ['id >= ?', rand_id])
    end

    respond_to do |format|
      format.html #first.html.erb
      format.json { render json: @card }
    end
  end

end
