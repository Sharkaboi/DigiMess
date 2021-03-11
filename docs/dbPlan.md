# DB plan

### **Users**   
  - UUID document name : *(String)*
    - username : *(String)*
    - hashedPassword : *(String)*
    - accountType : *(ENUM)*
    - isEnrolled : *(Boolean)*
    - cautionDepositAmount : *(Integer)*
    - details
      - name : *(String)*
      - yearOfAdmission : *(Date)*
      - yearOfCompletion : *(Date)*
      - branch : *(ENUM)*
      - dateOfBirth : *(Date)*
      - admissionNumber : *(String)*
      - phoneNumber : *(Integer)*
      - email : *(String)*
      - isVeg : *(Boolean)*

### **Menu**
- itemId
  - isVeg : *(Boolean)*
  - name : *(String)*
  - imageUrl : *(String)*
  - mealsAvailable : *(Array[Boolean])*
  - daysAvailable : *(Array[Boolean])*
  - isEnabled : *(Boolean)*
  - macros
    - calories : *(Float)*
    - protein : *(Float)*
    - fats : *(Float)*
    - carbohydrates : *(Float)*

### **Today's Menu**
- itemId : *(String)*
- mealPeriods : *(List<Boolean>)*
  
### **Payments**
- paymentId
  - userId : *(String)*
  - amount : *(Integer)*
  - date : *(DateTime)*
  - accountType : *(ENUM)*

### **Feedback**
- feedbackId
  - comment : *(String)*
  - userId : *(String)*
  - date : *(DateTime)*
  - rating : *(Integer)*