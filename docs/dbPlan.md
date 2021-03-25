# DB plan

### **Users**   
  - UUID document name : *(String)*
    - username : *(String)*
    - hashedPassword : *(String)*
    - accountType : *(String ENUM)*
    - isEnrolled : *(Boolean)*
    - cautionDepositAmount : *(Number)*
    - details : *(Map)*
      - name : *(String)*
      - yearOfAdmission : *(Timestamp)*
      - yearOfCompletion : *(Timestamp)*
      - branch : *(String ENUM)*
      - dob : *(Timestamp)*
      - phoneNumber : *(Number)*
      - email : *(String)*
      - isVeg : *(Boolean)*

### **Menu**
- itemId document name : *(String)*
  - isVeg : *(Boolean)*
  - name : *(String)*
  - imageUrl : *(String)*
  - isAvailable : *(Map)*
    - breakfast : *(Boolean)*
    - lunch : *(Boolean)*
    - dinner : *(Boolean)*
  - daysAvailable : *(Map)*
    - sunday : *(Boolean)*
    - monday : *(Boolean)*
    - tuesday : *(Boolean)*
    - wednesday : *(Boolean)*
    - thursday : *(Boolean)*
    - friday : *(Boolean)*
    - saturday : *(Boolean)*
  - isEnabled : *(Boolean)*
  - count : *(Number)*
  
### **Payments**
- paymentId : *(String)*
  - userId : *(String)*
  - amount : *(Number)*
  - date : *(Timestamp)*
  - accountType : *(String ENUM)*
  - description : *(String)*

### **Complaints**
- complaintId : *(String)*
  - complaint : *(String)*
  - category : *(Array<String>)*
  - userId : *(String)*
  - date : *(Timestamp)*

### **Notices**
- noticeId : *(String)*
  - title : *(String)*
  - date : *(Timestamp)*

### **Absentees**
- leaveEntryId : *(String)*
  - startDate : *(Timestamp)*
  - endDate : *(Timestamp)*
  - userId : *(String)*
  - applyDate : *(Timestamp)*
