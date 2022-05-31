class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.all
    @transactions = Transaction.where(product: params[:productName]) if params[:productName].present?

    if params[:total]
      @transactions = @transactions.group(:product).sum(:amount)

      @response = @transactions.map do |k, v| 
        { name: k, value: v }
      end

    elsif params[:by_day]
      gasoline_by_day = @transactions.where(product: 'gasoline').order(:transaction_date).group(:transaction_date).sum(:amount)
      ethanol_by_day  = @transactions.where(product: 'ethanol').order(:transaction_date).group(:transaction_date).sum(:amount)
      diesel_by_day   = @transactions.where(product: 'diesel').order(:transaction_date).group(:transaction_date).sum(:amount)

      @response = [
        { name: 'gasoline', series: gasoline_by_day.map{ |k, v| {name: k, value: v} }},
        { name: 'ethanol',  series: ethanol_by_day.map{ |k, v| {name: k, value: v} }},
        { name: 'diesel',   series: diesel_by_day.map{ |k, v| {name: k, value: v} }}
      ]
    else 
      @response = @transactions
    end

    render json: @response
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.require(:transaction).permit(:amount, :transaction_date, :product)
    end
end
