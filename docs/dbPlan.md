# DB plan

### **Users**   
  - UUID document name : *(String)*
    - username : *(String)*
    - hashedPassword : *(String)*
    - accountType : *(String ENUM)*
    - isEnrolled : *(Boolean)*
    - cautionDepositAmount : *(Number)*
    - details : *Map*
      - name : *(String)*
      - yearOfAdmission : *(Timestamp)*
      - yearOfCompletion : *(Timestamp)*
      - branch : *(String ENUM)*
      - dob : *(Timestamp)*
      - admissionNumber : *(String)*
      - phoneNumber : *(Number)*
      - email : *(String)*
      - isVeg : *(Boolean)*

### **Menu**
- itemId document name : *(String)*
  - isVeg : *(Boolean)*
  - name : *(String)*
  - imageUrl : *(String)*
  - isAvailable : *Map*
    - breakfast : *(Boolean)*
    - lunch : *(Boolean)*
    - snacks : *(Boolean)*
    - dinner : *(Boolean)*
  - daysAvailable : *Map*
    - sunday : *(Boolean)*
    - monday : *(Boolean)*
    - tuesday : *(Boolean)*
    - wednesday : *(Boolean)*
    - thursday : *(Boolean)*
    - friday : *(Boolean)*
    - saturday : *(Boolean)*
  - isEnabled : *(Boolean)*
  - macros : *Map*
    - calories : *(Number)*
    - protein : *(Number)*
    - fats : *(Number)*
    - carbohydrates : *(Number)*
  
### **Payments**
- paymentId : *(String)*
  - userId : *(String)*
  - amount : *(Number)*
  - date : *(Timestamp)*
  - accountType : *(String ENUM)*
  - description : *(String)*

### **Feedback**
- feedbackId : *(String)*
  - comment : *(String)*
  - userId : *(String)*
  - date : *(Timestamp)*
  - rating : *(Number)*
