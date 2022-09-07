import ballerina/io;

type studentRecord record {
    readonly int rollNo;
    record{
        string firstName;
        string lastName;
    } name;
    int totalMarks;
    int scienceMarks;
    int mathsMarks;
    int englishMarks;
    string address;
};

table<studentRecord> key(rollNo) studentRecordsTable = table[
    {
        rollNo:1,
        name : {firstName:"Ankit",lastName:"Singh"},
        totalMarks : 90,
        scienceMarks : 30,
        mathsMarks : 30,
        englishMarks : 30,
        address : "pune"
    },
    {
        rollNo:2,
        name : {firstName:"Kapil",lastName:"Tyagi"},
        totalMarks : 92,
        scienceMarks : 30,
        mathsMarks : 42,
        englishMarks : 20,
        address : "gurgaon"
    },
    {
        rollNo:3,
        name : {firstName:"Gaurav",lastName:"Patil"},
        totalMarks : 86,
        scienceMarks : 13,
        mathsMarks : 44,
        englishMarks : 45,
        address : "pune"
    },
    {
        rollNo:4,
        name : {firstName:"Rajesh",lastName:"Rajput"},
        totalMarks : 99,
        scienceMarks : 43,
        mathsMarks : 24,
        englishMarks : 15,
        address : "noida"
    },
    {
        rollNo:5,
        name : {firstName:"Dilip",lastName:"Yadav"},
        totalMarks : 91,
        scienceMarks : 21,
        mathsMarks : 40,
        englishMarks : 30,
        address : "pune"
    }
];

public function main() {
    // people whose address in pune
    [string,string][] peopleFromPune = studentFromRespectiveCity(studentRecordsTable,"pune");
    io:println("students from pune");
    io:println(peopleFromPune);

    // people whose address in noida
    [string,string][] peopleFromNoida = studentFromRespectiveCity(studentRecordsTable,"noida");
    io:println("students from noida");
    io:println(peopleFromNoida);

    // people whose address in  gurgaon
    [string,string][] peopleFromGurgaon = studentFromRespectiveCity(studentRecordsTable,"gurgaon");
    io:println("students from gurgaon");
    io:println(peopleFromGurgaon);

    // top 3 students with highest marks
    [string,string,int][] top3Students = studentWIthHigeshMarks(studentRecordsTable,3);
    io:println("top 3 highesh student marks");
    io:println(top3Students);

    // students whose total marks calculation is wrong
    string[] ErrorsStudents = checkIfTotalMarksIsCorrect(studentRecordsTable);
    if ErrorsStudents.length() > 0{
        io:println("There are some students whose total marks is wrong following are the students");
        io:println(ErrorsStudents);
    }
}

function studentFromRespectiveCity(table<studentRecord> data,string city) returns [string,string][]{
    [string,string][] peopleFromAddress = from studentRecord entry in data
                                            where entry.address == city
                                            select [entry.name.firstName,entry.name.lastName];

    return peopleFromAddress;
}

function studentWIthHigeshMarks(table<studentRecord> data,int n) returns [string,string,int][]{
    [string,string,int][] higheshMarksStudents = from studentRecord entry in data
                                            order by entry.totalMarks descending
                                            limit n
                                            select [entry.name.firstName,entry.name.lastName,entry.totalMarks];
    return higheshMarksStudents;
}

function checkIfTotalMarksIsCorrect(table<studentRecord> data) returns string[]{
        string[] totalMarksError = from studentRecord entry in data
                                let int sum = entry.englishMarks + entry.mathsMarks + entry.scienceMarks
                                where entry.totalMarks != sum
                                select entry.name.firstName;
        return totalMarksError;
}

