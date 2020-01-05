function pesel2Age(pesel){
	var yearStr = pesel.substring(0, 2);
  var monStr = parseInt(pesel.substring(2, 4), 10);
  var dayStr = pesel.substring(4, 6);
  var yearPref = monStr > 12 ? '20' : '19';
  var monParsed = monStr > 12 ?monStr - 20 : monStr;
  // console.log(pesel, yearStr, monStr, dayStr);
  return new Date(`${yearPref + yearStr}-${monParsed}-${dayStr}`);
}
var pesel1 = '85121320343'
var pesel2 = '04320601569'
console.log(pesel2Age(pesel1), pesel2Age(pesel2))
