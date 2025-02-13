window.addEventListener("message", function(event) {
    const data = event.data;

    if (data.action === 'updateTopHud') {
        document.getElementById('cash').textContent = data.cash + ' €';
        document.getElementById('bank').textContent = data.bank + ' €';
        document.getElementById('job').textContent = data.job + ' - ' + data.grade;
    }

    if (data.action === 'openHudStyling') {
        document.getElementById('hud-styling').style.display = 'block';
        document.body.style.cursor = 'default'; // Show cursor
    }

    if (data.action === 'closeHudStyling') {
        document.getElementById('hud-styling').style.display = 'none';
        document.body.style.cursor = 'none'; // Hide cursor
        fetch(`https://${GetParentResourceName()}/closeHudStyling`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        }).catch(error => console.error('Error:', error));
    }
});

function closeHudStyling() {
    document.getElementById('hud-styling').style.display = 'none';
    document.body.style.cursor = 'none'; // Hide cursor
    fetch(`https://${GetParentResourceName()}/closeHudStyling`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(() => {
        $.post(`https://${GetParentResourceName()}/closeHudStyling`); // Notify server to disable cursor mode
    }).catch(error => console.error('Error:', error));
}

document.getElementById('saveSettings').addEventListener('click', function() {
    const cashColor = document.getElementById('cashColor').value;
    const bankColor = document.getElementById('bankColor').value;
    const jobColor = document.getElementById('jobColor').value;
    const bgOpacity = document.getElementById('bgOpacity').value;

    document.querySelector('.hud_element i.fa-money').style.color = cashColor;
    document.querySelector('.hud_element i.fa-bank').style.color = bankColor;
    document.querySelector('.hud_element i.fa-briefcase').style.color = jobColor;

    document.getElementById('cash').style.color = cashColor;
    document.getElementById('bank').style.color = bankColor;
    document.getElementById('job').style.color = jobColor;

    document.querySelector('.tophud').style.backgroundColor = `rgba(0, 0, 0, ${bgOpacity / 100})`;

    fetch(`https://${GetParentResourceName()}/saveHudSettings`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            cashColor: cashColor,
            bankColor: bankColor,
            jobColor: jobColor,
            bgOpacity: bgOpacity
        })
    }).then(() => {
        closeHudStyling();
    }).catch(error => console.error('Error:', error));
});

document.getElementById('cancelSettings').addEventListener('click', function() {
    closeHudStyling();
});

document.getElementById('closeHudStyling').addEventListener('click', function() {
    closeHudStyling();
});