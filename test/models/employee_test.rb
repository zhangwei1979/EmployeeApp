require "test_helper"

class EmployeeTest < ActiveSupport::TestCase

  test "create employee" do

    employee = Employee.new(first_name: "David", last_name: "John")

    assert employee.save

    savedEmployee = Employee.find(employee.id).first
    assert employee.first_name=="David"
    assert employee.last_name=="John"

  end

  test "create contract" do

    start_date = Date.parse('2020-01-01')
    end_date = Date.parse('2020-12-31')
    legal = 'Shinetech'

    contract = Contract.new(start_date: start_date, end_date: end_date, legal: legal)
    assert contract.save

    contract = Contract.new(start_date: start_date, end_date: end_date)
    assert !contract.valid?

    contract = Contract.new(end_date: end_date, legal: legal)
    # assert contract.valid?

    contract = Contract.new(start_date: start_date, legal: legal)
    # assert contract.valid?


    # end date > start date
    contract = Contract.new(start_date: '2020-01-31', end_date: '2020-01-01', legal: legal)
    assert !contract.valid?

    # overlap if there there is any reocords in db
    contract = Contract.new(legal: legal)
    assert !contract.valid?

    #start date is nil and end date is not nil, overlap if the 
    contract = Contract.new(end_date: end_date, legal: legal)
    assert !contract.valid?


  end

  test "create contract date overlap with end date nil" do
    start_date = Date.parse('2020-01-01')
    end_date = Date.parse('2020-12-31')
    legal = 'Shinetech'

    contract = Contract.new(start_date: start_date, end_date: end_date, legal: legal)
    assert contract.save

    contract = Contract.new(start_date: start_date, legal: legal)
    assert !contract.valid?
  end

  test "create contract date overlap with start date nil" do
    start_date = Date.parse('2020-01-01')
    end_date = Date.parse('2020-12-31')
    legal = 'Shinetech'

    contract = Contract.new(start_date: start_date, end_date: end_date, legal: legal)
    assert contract.save

    contract = Contract.new(end_date: end_date, legal: legal)
    assert !contract.valid?
  end

  test "create contract date overlap with start date and end_date" do
    start_date = Date.parse('2020-01-01')
    end_date = Date.parse('2020-01-31')
    legal = 'Shinetech'

    contract = Contract.new(start_date: start_date, end_date: end_date, legal: legal)
    assert contract.save

    contract = Contract.new(start_date: Date.parse('2020-01-02'), end_date: Date.parse('2020-02-02'), legal: legal)
    assert !contract.valid?

    contract = Contract.new(start_date: Date.parse('2020-02-01'), end_date: Date.parse('2020-02-28'), legal: legal)
    assert contract.valid?

    contract = Contract.new(start_date: Date.parse('2019-01-01'), end_date: Date.parse('2019-12-31'), legal: legal)
    assert contract.valid?

    contract = Contract.new(legal: legal)
    assert !contract.valid?

  end




  test "search employee" do

    employee = Employee.new(first_name: "David", last_name: "John")
    employee.save
    employee_list = EmployeeService.new.search 'david'

    assert employee_list.first.first_name== 'David'
   
  end
end
