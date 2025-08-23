import { useEffect, useMemo, useRef, useState } from 'react'
import './App.css'

function App() {
  const API_BASE = import.meta.env.VITE_API_BASE || '/api'
  const [problems, setProblems] = useState([])
  const [runtimes, setRuntimes] = useState([])
  const [problemId, setProblemId] = useState('')
  const [runtimeId, setRuntimeId] = useState('')
  const [code, setCode] = useState('print(1)')
  const [subId, setSubId] = useState('')
  const [status, setStatus] = useState('')
  const [events, setEvents] = useState([])
  const esRef = useRef(null)

  useEffect(() => {
    fetch(`${API_BASE}/problems`).then(r => r.json()).then(setProblems)
    fetch(`${API_BASE}/language-runtimes`).then(r => r.json()).then(setRuntimes)
  }, [])

  const submit = async () => {
    if (!problemId || !runtimeId) return alert('Select problem and language')
    const res = await fetch(`${API_BASE}/submissions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ problem_id: Number(problemId), language_runtime_id: Number(runtimeId), source_code: code })
    })
    const data = await res.json()
    setSubId(data.submission_id)
    setEvents([])
    setStatus('queued')
    startStream(data.submission_id)
  }

  const startStream = (id) => {
    if (esRef.current) {
      esRef.current.close()
    }
    const es = new EventSource(`${API_BASE}/submissions/${id}/events`)
    esRef.current = es
    es.onmessage = (e) => {
      try {
        setEvents(prev => [...prev, { type: 'message', payload: e.data }])
      } catch {}
    }
    es.addEventListener('final', (e) => {
      setEvents(prev => [...prev, { type: 'final', payload: e.data }])
      setStatus('completed')
      es.close()
    })
    es.addEventListener('compile_start', (e) => setEvents(prev => [...prev, { type: 'compile_start', payload: e.data }]))
    es.addEventListener('compile_end', (e) => setEvents(prev => [...prev, { type: 'compile_end', payload: e.data }]))
    es.addEventListener('testcase_start', (e) => setEvents(prev => [...prev, { type: 'testcase_start', payload: e.data }]))
    es.addEventListener('testcase_end', (e) => setEvents(prev => [...prev, { type: 'testcase_end', payload: e.data }]))
  }

  return (
    <div className="container">
      <div className="header">
        <div>
          <h1>Challenge Evaluation</h1>
          <div className="subtle">Submit code and see live progress</div>
        </div>
      </div>

      <div className="panel">
        <div className="controls">
          <select className="select" value={problemId} onChange={e => setProblemId(e.target.value)}>
            <option value="">Select Problem</option>
            {problems.map(p => <option key={p.id} value={p.id}>{p.title || p.slug}</option>)}
          </select>
          <select className="select" value={runtimeId} onChange={e => setRuntimeId(e.target.value)}>
            <option value="">Select Language</option>
            {runtimes.map(r => <option key={r.id} value={r.id}>{r.name} {r.version}</option>)}
          </select>
          <button className="button" onClick={submit} disabled={!problemId || !runtimeId}>Submit</button>
        </div>
        <div className="editor">
          <textarea className="code-editor" value={code} onChange={e => setCode(e.target.value)} rows={12} />
        </div>
        <div className="statusbar">
          <div>Submission: {subId || '-'}</div>
          <div>Status: {status || '-'}</div>
        </div>
      </div>

      <div className="events panel">
        <div className="subtle" style={{marginBottom: 8}}>Events</div>
        <pre>
          {events.map((e, i) => `${i+1}. [${e.type}] ${e.payload}\n`).join('')}
        </pre>
      </div>
    </div>
  )
}

export default App
